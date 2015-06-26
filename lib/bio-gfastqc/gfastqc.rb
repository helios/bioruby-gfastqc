
module Bio
  class GFASTQC
    attr_accessor :data, :tables, :config, :output, :base_file_names, :step
    attr_accessor :type_images #An array of names of images that must be reported into the html page
    attr_accessor :type_tables #An array of names of tables that must be reported into the html page 
    attr_reader :options

    def initialize(options=OpenStruct.new)
      @options = options
      @config = YAML.load_file(options.config)
      @data = Hash.new { |hash, key| hash[key] = Hash.new { |ihash, ikey| ihash[ikey] = {} } }
      @tables = Hash.new { |hash, key| hash[key] = Hash.new { |ihash, ikey| ihash[ikey] = {} } }
      @base_file_names = []
      @base_file_names << options.first #this must be mandatory
      @base_file_names << options.second if options.second # this can be optional
      @step = options.step

      if options.pipengine 
        unless @config['resources'] && @config['resources']['output']
          raise "Error: If you selected the compatible option -p/--pipengine, an 'output' tag must occour in your configuration file."
        end
      end #pipengine

      @output = get_output

      read_each_sample

    end #initialize

    def use_pipengine?
      @options.pipengine
    end 

    def use_groups?
      @options.groups
    end

    def use_sample_name?
      @options.usename
    end

    def samples
      @config['samples']
    end

    protected

    def process_sample(sample_name, path, group_name='')

      base_file_names.each do |base_file_name|
        # data[name][base_file_name]={}
        # tables[name][base_file_name]={}
        filename = use_sample_name? ? "#{name}_#{base_file_name}" : base_file_name
        file = File.join(use_pipengine? ? File.join(output, group_name, sample_name) : path, step, "#{filename}_fastqc.zip")
        Zip::File.open(file) do |zip_file|
          zip_file.glob('*/Images/*.png').each do |entry|
            field_name = File.basename(entry.name,".png")
            data[sample_name][base_file_name][field_name]=Base64.encode64(entry.get_input_stream.read)
          end #each entry
          zip_file.glob('*/fastqc_data.txt').each do |entry|
            entry.get_input_stream.read.scan(/>>(.*?)>>END_MODULE/m).each do |match|
              match_data = match.first.split("\n")
              field_name, status = match_data[0].split("\t")
              begin 
              if field_name == "Overrepresented sequences" && status == 'pass'
                header = []
                content = []
              else
                header = match_data[1].tr("#","").split("\t")
                content = match_data[2..-1].map do |data_row|
                  data_row.split("\t")
                end
              end
                # puts field_name
                # puts header
                field_name = field_name.tr(" ","_")
                tables[sample_name][base_file_name][field_name]={ "status" => status,
                  "header"=> header,
                  "content" => content
                }
              rescue
               $stderr.puts match.inspect #This is a generic warning to notify the user that this records has no data associated with.
               $stderr.puts field_name
               $stderr.puts status
              end #begin

            end #match
          end #fastq data.txt
        end #zip
      end #files

    end #process_sample


    def read_each_sample
      if options.groups
      #both are exact the name only iterate on groups and the other only on samples (without groups)
        samples.each_pair do |group_name, sample|
          sample.each_pair do |sample_name, path|
            process_sample(sample_name, path, group_name)
          end #iterate over samples
        end #iterage over groups
      else
        samples.each_pair do |sample_name, path|
          process_sample(sample_name, path)
        end #iterate over samples
      end #groups or not
    end 



    
    def get_output
      if @config['output']
        @config['output']
      elsif options.pipengine && @config['resources'] && @config['resources']['output']
        @config['resources']['output']
      elsif @config['resources'] && @config['resources']['output']
        @config['resources']['output']
      else
        '.'
      end #output
    end #get_output  


  end #GFASTQC
end #Bio
