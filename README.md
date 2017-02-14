# NAME

Datahub::Factory - A conveyor belt which transports data from a data source to
a Datahub instance.

# SYNOPSIS

dhconveyor \[ARGUMENTS\] \[OPTIONS\]

# DESCRIPTION

Datahub::Factory is a command line conveyor belt which automates three tasks:

- Data is fetched automatically from a local or remote data source.
- Data is converted to an exchange format.
- The output is pushed to an operational Datahub instance.

Internally, Datahub::Factory uses Catmandu modules to transform the data, and
implements the Datahub REST API. Datahub::Factory stitches the transformation
and push tasks seamlessly together.

Datahub::Factory contains Log4perl support to monitor conveyor belt operations.

Note: This toolset is not a generic tool. It has been tailored towards the
functional requirements of the Flemish Art Collection use case.

# COMMANDS

## help COMMAND

Documentation about command line options.

It is possible to provide either all importer and/or exporter options on the
command line, or to create a _pipeline configuration file_ that sets those
options.

## transport \[OPTIONS\]

Fetch data from a local or remote source, convert it to an exchange format and
push the data to a Datahub instance.

### Command line options

\--importer NAME
   The importer which fetches data from a Collection Registration system.
   Currently only "Adlib" and "TMS" are supported options.
   All `--oimport` arguments are tied to the specific importer used.

\--fixes PATH
  The path to the Catmandu Fix files to transform the data.

\--exporter NAME
  The exporter that will do something with your data. It is possible to
  print to `STDOUT` in a specific format ("YAML" and "LIDO" are supported)
  or to export to a Datahub instance.
  All `--oexport` arguments are tied to the specific exporter used.

\--oimport file\_name=PATH
  The path to a flat file containing data. This option is only relevant when
  the input is an Adlib XML export file.

\--oimport db\_user=VALUE
  The database user. This option is only relevant when
  the input is an TMS database.

\--oimport db\_passowrd=VALUE
  The database user password. This option is only relevant when
  the input is an TMS database.

\--oimport db\_name=VALUE
  The database name. This option is only relevant when
  the input is an TMS database.

\--oimport db\_host=VALUE
  The database host. This option is only relevant when
  the input is an TMS database.

\--oexport datahub\_url=VALUE
  The URL to the datahub instance. This should be a FQDN ie. http://datahub.lan/

\--oexport oauth\_client\_id=VALUE
  The client public ID. Used for OAuth authentication of the Datahub endpoint.

\--oexport oauth\_client\_secret=VALUE
  The client secret passphrase. Used for OAuth authentication of the Datahub
  endpoint.

\--oexport oauth\_username=VALUE
  The username of the Datahub user. Used for OAuth authentication of the Datahub
  endpoint.

\--oexport oauth\_password=VALUE
  The password of the Datahub user. Used for OAuth authentication of the Datahub
  endpoint.

### Pipeline configuration file

The _pipeline configuration file_ is in the `INI` format and its location is
provided to the application using the `--pipeline` switch.

The file is broadly divided in two parts: the first (shortest) part configures
the pipeline itself and sets the plugins to use for the _import_, _fix_ and
_export_ actions. The second part sets options specific for the used plugins.

#### Pipeline configuration

This part has three sections: `[Importer]`, `[Fixer]` and `[Exporter]`.
Every section has just one option: `plugin`. Set this to the plugin you
want to use for every action.

All current supported plugins are in the `Importer` and `Exporter` folders.
For the `[Fixer]`, only the _Fix_ plugin is supported.

Supported _Importer_ plugins:

- [TMS](https://metacpan.org/pod/Datahub::Factory::Importer::TMS)
- [Adlib](https://metacpan.org/pod/Datahub::Factory::Importer::Adlib)
- [KMSKA](https://metacpan.org/pod/Datahub::Factory::Importer::KMSKA)
- [MSK](https://metacpan.org/pod/Datahub::Factory::Importer::MSK)
- [VKC](https://metacpan.org/pod/Datahub::Factory::Importer::VKC)

Supported _Exporter_ plugins:

- [Datahub](https://metacpan.org/pod/Datahub::Factory::Exporter::Datahub)
- [LIDO](https://metacpan.org/pod/Datahub::Factory::Exporter::LIDO)
- [YAML](https://metacpan.org/pod/Datahub::Factory::Exporter::YAML)

#### Plugin configuration

All plugins have their own configuration options in sections called
`[plugin_type_name]` where `type` can be _importer_, _exporter_
or _fixer_ and `name` is the name of the plugin (see above).

For a list of supported and required options, see the plugin documentation.

#### Example configuration file

    [Importer]
    plugin = Adlib

    [Fixer]
    plugin = Fix

    [Exporter]
    plugin = Datahub

    [plugin_importer_Adlib]
    file_name = '/tmp/adlib.xml'
    data_path = 'recordList.record.*'

    [plugin_fixer_Fix]
    fix_file = '/tmp/msk.fix'

    [plugin_exporter_Datahub]
    datahub_url = my.thedatahub.io
    datahub_format = LIDO
    oauth_client_id = datahub
    oauth_client_secret = datahub
    oauth_username = datahub
    oauth_password = datahub

# AUTHORS

- Pieter De Praetere <pieter@packed.be>
- Matthias Vandermaesen <matthias.vandermaesen@vlaamsekunstcollectie.be>

# COPYRIGHT

Copyright 2016 - PACKED vzw, Vlaamse Kunstcollectie vzw

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the terms of the GPLv3.
