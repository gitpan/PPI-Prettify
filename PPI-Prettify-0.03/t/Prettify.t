use strict;
use warnings;
use Test::More;
use PPI::Prettify;
use PPI::Document;

my $code;
read( main::DATA, $code, 1000 );
my $doc    = PPI::Document->new( \$code );
my @tokens = $doc->tokens;

ok( expectedOutput() eq prettify( { code => $code } ), 'Test expected output' );

eval { prettify() };
ok( $@, 'Test failure on missing code arg' );

ok( $tokens[0]->isa('PPI::Token::Comment'),     'Token tree starting type' );
ok( $tokens[99]->isa('PPI::Token::Whitespace'), 'Token tree ending type' );
ok( 'PPI::Token::Function' eq PPI::Prettify::_determineToken( $tokens[66] ),
    '_decorate identifies foreach as a keyword type' );
ok( 'PPI::Token::Word' eq PPI::Prettify::_determineToken( $tokens[84] ),
    '_decorate identifies _toHTML as a word type' );

done_testing();

sub expectedOutput {
    return q!<pre class="prettyprint"><span class="com">#SOME COMMENTS
</span><span class="pln">
</span><span class="com">=pod
    some pod
=cut
</span><span class="pln">
</span><span class="kwd">use</span><span class="pln"> </span><span class="atn">strict</span><span class="pln">;</span><span class="pln">
</span><span class="kwd">use</span><span class="pln"> </span><span class="atn">warnings</span><span class="pln">;</span><span class="pln">
</span><span class="kwd">package</span><span class="pln"> </span><span class="atn">PPI::Prettify</span><span class="pln">;</span><span class="pln">
</span><span class="pln">
</span><span class="kwd">use</span><span class="pln"> </span><span class="atn">PPI::Document</span><span class="pln">;</span><span class="pln">
</span><span class="kwd">use</span><span class="pln"> </span><span class="atn">feature</span><span class="pln"> </span><span class="str">&#39;say&#39;</span><span class="pln">;</span><span class="pln">
</span><span class="pln">
</span><span class="kwd">our</span><span class="pln"> </span><span class="typ">$MARKUP_RULES</span><span class="pln"> </span><span class="pln">=</span><span class="pln"> </span><span class="pln">{</span><span class="pln">
</span><span class="str">&#39;PPI::Token::Whitespace&#39;</span><span class="pln"> </span><span class="pln">=&gt;</span><span class="pln"> </span><span class="str">&#39;pln&#39;</span><span class="pln">,</span><span class="pln">
</span><span class="str">&#39;PPI::Token::Comment&#39;</span><span class="pln"> </span><span class="pln">=&gt;</span><span class="pln"> </span><span class="str">&#39;com&#39;</span><span class="pln">,</span><span class="pln">
</span><span class="pln">}</span><span class="pln">;</span><span class="pln">
</span><span class="pln">
</span><span class="kwd">sub</span><span class="pln"> </span><span class="atn">_decorate</span><span class="pln"> </span><span class="pln">{</span><span class="pln">
</span><span class="pln">    </span><span class="kwd">foreach</span><span class="pln"> </span><span class="kwd">my</span><span class="pln"> </span><span class="typ">$token</span><span class="pln"> </span><span class="pln">(</span><span class="typ">$_</span><span class="pln">[</span><span class="dec">0</span><span class="pln">]</span><span class="pln">-&gt;</span><span class="atn">tokens</span><span class="pln">)</span><span class="pln"> </span><span class="pln">{</span><span class="pln">
</span><span class="pln">        </span><span class="atn">_toHTML</span><span class="pln">(</span><span class="typ">$token</span><span class="pln">)</span><span class="pln">;</span><span class="pln">
</span><span class="pln">    </span><span class="pln">}</span><span class="pln">
</span><span class="pln">
</span><span class="pln">}</span><span class="pln">
</span><span class="pln">
</span><span class="dec">1</span><span class="pln">;</span><span class="pln">
</span></pre>!;
}

__DATA__
#SOME COMMENTS

=pod
    some pod
=cut

use strict;
use warnings;
package PPI::Prettify;

use PPI::Document;
use feature 'say';

our $MARKUP_RULES = {
'PPI::Token::Whitespace' => 'pln',
'PPI::Token::Comment' => 'com',
};

sub _decorate {
    foreach my $token ($_[0]->tokens) {
        _toHTML($token);
    }

}

1;
