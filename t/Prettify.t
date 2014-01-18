use strict;
use warnings;
use Test::More tests => 13;
use PPI::Prettify;
use PPI::Document;

read( main::DATA, my $code, 1000 );
my $doc    = PPI::Document->new( \$code );
my @tokens = $doc->tokens;

# for debugging
if ( @ARGV and $ARGV[0] == 1 ) {
    print "Dumping tokens and values ...\n";
    for ( my $i = 0 ; $i < @tokens ; $i++ ) {
        print $i . ' '
          . ref( $tokens[$i] ) . ' '
          . $tokens[$i]->content . ' '
          . PPI::Prettify::_determineToken( $tokens[$i] ) . "\n";
    }
}

eval { prettify() };
ok( $@, 'Test failure on missing code arg' );
ok( 'PPI::Token::Keyword' eq PPI::Prettify::_determineToken( $tokens[0] ),
    'Package keyword identified as keyword' );
ok(
    'PPI::Token::Word::Package' eq PPI::Prettify::_determineToken( $tokens[2] ),
    'Package name identified as package'
);
ok( 'PPI::Token::Function' eq PPI::Prettify::_determineToken( $tokens[10] ),
    'use identified as function' );
ok( 'PPI::Token::Pragma' eq PPI::Prettify::_determineToken( $tokens[12] ),
    'warnings identified as pragma' );
ok(
    'PPI::Token::KeywordFunction' eq
      PPI::Prettify::_determineToken( $tokens[28] ),
    'BEGIN identified as keyword'
);
ok( 'PPI::Token::Pragma' eq PPI::Prettify::_determineToken( $tokens[41] ),
    'base identified as pragma' );
ok( 'PPI::Token::Symbol' eq PPI::Prettify::_determineToken( $tokens[49] ),
    '@EXPORT identified as symbol' );
ok( 'PPI::Token::Keyword' eq PPI::Prettify::_determineToken( $tokens[63] ),
    'sub identified as keyword type' );
ok( 'PPI::Token::Symbol' eq PPI::Prettify::_determineToken( $tokens[82] ),
    'length identified as symbol not built-in' );
ok( 'PPI::Token::Symbol' eq PPI::Prettify::_determineToken( $tokens[191] ),
    'STDOUT identified as symbol' );
ok( 'PPI::Token::Quote' eq PPI::Prettify::_determineToken( $tokens[200] ),
    'uc identified as quote not built-in' );
ok( 'PPI::Token::Separator' eq PPI::Prettify::_determineToken( $tokens[212] ),
    '__END__ identified as separator' );

__DATA__
package Test::Package;
use strict;
use warnings;
use feature 'say';
use Example::Module;

BEGIN {
    require Exporter;
    use base qw(Exporter);
    our @EXPORT = ('example_sub');
}

=head2 example_sub

example_sub is an example sub the subroutine markup;

=cut

sub example_sub {
    my $self = shift;
    $self->length;
    return $self->do_something;
}

# this is a comment for do_something, an example method

sub do_something {
    my ($self) = @_;
    if ('dog' eq "cat") {
        say 1 * 564;
    }
    else {
        say 100 % 101;
    }
    return 'a string';
}

# example variables
my @array = qw/1 2 3/;
my $scalar = 'a plain string';

print STDOUT $scalar;
example_sub({ uc => 'test uc is string not BIF'});
1;
__END__
