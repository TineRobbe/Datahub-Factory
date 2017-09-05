requires 'perl', '5.008005';

# requires 'Some::Module', 'VERSION';

requires 'Catmandu', '1.0603';
requires 'App::Cmd';
requires 'Config::Simple';
requires 'Catmandu::LIDO';
requires 'Catmandu::Store::Datahub';
requires 'Catmandu::Store::Resolver';
requires 'Lido::XML';
requires 'Log::Any';
requires 'Log::Log4perl';
requires 'LWP::UserAgent';
requires 'Module::Load';
requires 'Moo';
requires 'MooX::Aliases';
requires 'MooX::Role::Logger';
requires 'namespace::clean';
requires 'Sub::Exporter';
requires 'Catmandu::OAI';
requires 'Catmandu::Solr';
requires 'Catmandu::Importer::XML';
requires 'Hash::Merge';
requires "Ref::Util";
requires "DateTime";
requires 'Term::ANSIColor';
requires 'Try::Tiny';

# https://github.com/libwww-perl/libwww-perl/issues/201
conflicts "LWP::Authen::Negotiate";

on test => sub {
    requires 'Test::More', '0.96';
};
