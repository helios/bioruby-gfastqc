# bio-gfastqc

[![Build Status](https://secure.travis-ci.org/helios/bioruby-gfastqc.png)](http://travis-ci.org/helios/bioruby-gfastqc)

Bioinformatics. Aggregate FastQC (quality control for Next Generation Sequencing -NGS-) results from many different samples in a single web page, with charts and tables organized and simplified. The main goal is to speed up the communication process with colleagues (PIs, Biologists, BioInformaticians).

Note: this software is under active development!

## Installation

```sh
gem install bio-gfastqc
```

## Usage

```ruby
require 'bio-gfastqc'
```

The API doc is online. For more code examples see the test files in
the source tree.

Note: at this time there is not a real API, it will follow.
        
## Project home page

Information on the source tree, documentation, examples, issues and
how to contribute, see

  http://github.com/helios/bioruby-gfastqc

The BioRuby community is on IRC server: irc.freenode.org, channel: #bioruby.


Create a config YAML file 

    config.yml

it contents is for example:

    samples:
      Sample_A: /path_to_sampleA
      Sample_B: /path_to_sampleB

then run the script in the directory of the `config.yml` file and specify the sub directory for each sampel where is located the result of the FASTQC

    gfastqc -a R1 -b R2

in case you have the results of FastQC in a sub folder and you want to keep the definition of the sample independen from it, you can use the step option

    gfastqc -a R1 -b R2 --step qc_pre_trimming

Then open index.html in your browser

### Pipengine
Pipengine, https://github.com/fstrozzi/bioruby-pipengine, a simple launcher for complex biological pipelines. Because we are developing it we found usefult to reuse some best practices from it. An example is the `-s/--step` options which let you select the sample inner directory from which grab the FastQC results. In the current examples we defined just samples and their absolut path, but following the Pipengine directives it is necessary to define another tag:

    output: /path/where_the_pipe_engine_data_are_processed_and_saved

to reuse that tag from gfastqc the user can simply select the option

    -p/--pipengine

the software will look for the results of single fastqc applied to the different samples in the `output` directory.



## TODO

* ~~read output tag from sample config file (YAML)~~
* ~~add reference to pipengine~~
* avoid user to specify -a and -b. By default discover zip files and ordering them define the first and second strand.
* ~~package everything as a gem~~
* provide better documentation for installing the gem on multiple system (GNU/Linux, OSX, Windows)


## Cite

If you use this software, please cite one of
  
* [BioRuby: bioinformatics software for the Ruby programming language](http://dx.doi.org/10.1093/bioinformatics/btq475)
* [Biogem: an effective tool-based approach for scaling up open source software development in bioinformatics](http://dx.doi.org/10.1093/bioinformatics/bts080)

## Biogems.info

This Biogem is published at (http://biogems.info/index.html#bio-gfastqc)

## Copyright

Copyright (c) 2015 Raoul Jean Pierre Bonnal. See LICENSE.txt for further details.

