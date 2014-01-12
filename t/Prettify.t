use strict;
use warnings;
use Test::More;
use PPI::Prettify;
use PPI::Document;

my $code;
read( main::DATA, $code, 1000 );
my $doc = PPI::Document->new( \$code );

# Please excuse this ugly start, see TESTS below

my $expectedOutput = q!<pre class="prettyprint"><span class="com">#SOME COMMENTS
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
</span><span class="kwd">use</span><span class="pln"> </span><span class="atn">feature</span><span class="pln"> </span><span class="str">'say'</span><span class="pln">;</span><span class="pln">
</span><span class="pln">
</span><span class="kwd">our</span><span class="pln"> </span><span class="typ">$MARKUP_RULES</span><span class="pln"> </span><span class="pln">=</span><span class="pln"> </span><span class="pln">{</span><span class="pln">
</span><span class="str">'PPI::Token::Whitespace'</span><span class="pln"> </span><span class="pln">=></span><span class="pln"> </span><span class="str">'pln'</span><span class="pln">,</span><span class="pln">
</span><span class="str">'PPI::Token::Comment'</span><span class="pln"> </span><span class="pln">=></span><span class="pln"> </span><span class="str">'com'</span><span class="pln">,</span><span class="pln">
</span><span class="pln">}</span><span class="pln">;</span><span class="pln">
</span><span class="pln">
</span><span class="kwd">sub</span><span class="pln"> </span><span class="atn">_decorate</span><span class="pln"> </span><span class="pln">{</span><span class="pln">
</span><span class="pln">    </span><span class="kwd">foreach</span><span class="pln"> </span><span class="kwd">my</span><span class="pln"> </span><span class="typ">$token</span><span class="pln"> </span><span class="pln">(</span><span class="typ">$_</span><span class="pln">[</span><span class="dec">0</span><span class="pln">]</span><span class="pln">-></span><span class="atn">tokens</span><span class="pln">)</span><span class="pln"> </span><span class="pln">{</span><span class="pln">
</span><span class="pln">        </span><span class="atn">_toHTML</span><span class="pln">(</span><span class="typ">$token</span><span class="pln">)</span><span class="pln">;</span><span class="pln">
</span><span class="pln">    </span><span class="pln">}</span><span class="pln">
</span><span class="pln">
</span><span class="pln">}</span><span class="pln">
</span><span class="pln">
</span><span class="dec">1</span><span class="pln">;</span><span class="pln">
</span></pre>!;

my $expectedDebugOutput =
  q!<pre class="prettyprint"><span class="com" title="PPI::Token::Comment">#SOME COMMENTS
</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="com" title="PPI::Token::Pod">=pod
    some pod
=cut
</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="kwd" title="PPI::Token::Function">use</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="atn" title="PPI::Token::Word">strict</span><span class="pln" title="PPI::Token::Structure">;</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="kwd" title="PPI::Token::Function">use</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="atn" title="PPI::Token::Word">warnings</span><span class="pln" title="PPI::Token::Structure">;</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="kwd" title="PPI::Token::Function">package</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="atn" title="PPI::Token::Word">PPI::Prettify</span><span class="pln" title="PPI::Token::Structure">;</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="kwd" title="PPI::Token::Function">use</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="atn" title="PPI::Token::Word">PPI::Document</span><span class="pln" title="PPI::Token::Structure">;</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="kwd" title="PPI::Token::Function">use</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="atn" title="PPI::Token::Word">feature</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="str" title="PPI::Token::Quote::Single">'say'</span><span class="pln" title="PPI::Token::Structure">;</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="kwd" title="PPI::Token::Function">our</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="typ" title="PPI::Token::Symbol">$MARKUP_RULES</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="pln" title="PPI::Token::Operator">=</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="pln" title="PPI::Token::Structure">{</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="str" title="PPI::Token::Quote::Single">'PPI::Token::Whitespace'</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="pln" title="PPI::Token::Operator">=></span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="str" title="PPI::Token::Quote::Single">'pln'</span><span class="pln" title="PPI::Token::Operator">,</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="str" title="PPI::Token::Quote::Single">'PPI::Token::Comment'</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="pln" title="PPI::Token::Operator">=></span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="str" title="PPI::Token::Quote::Single">'com'</span><span class="pln" title="PPI::Token::Operator">,</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="pln" title="PPI::Token::Structure">}</span><span class="pln" title="PPI::Token::Structure">;</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="kwd" title="PPI::Token::Function">sub</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="atn" title="PPI::Token::Word">_decorate</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="pln" title="PPI::Token::Structure">{</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="pln" title="PPI::Token::Whitespace">    </span><span class="kwd" title="PPI::Token::Function">foreach</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="kwd" title="PPI::Token::Function">my</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="typ" title="PPI::Token::Symbol">$token</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="pln" title="PPI::Token::Structure">(</span><span class="typ" title="PPI::Token::Magic">$_</span><span class="pln" title="PPI::Token::Structure">[</span><span class="dec" title="PPI::Token::Number">0</span><span class="pln" title="PPI::Token::Structure">]</span><span class="pln" title="PPI::Token::Operator">-></span><span class="atn" title="PPI::Token::Word">tokens</span><span class="pln" title="PPI::Token::Structure">)</span><span class="pln" title="PPI::Token::Whitespace"> </span><span class="pln" title="PPI::Token::Structure">{</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="pln" title="PPI::Token::Whitespace">        </span><span class="atn" title="PPI::Token::Word">_toHTML</span><span class="pln" title="PPI::Token::Structure">(</span><span class="typ" title="PPI::Token::Symbol">$token</span><span class="pln" title="PPI::Token::Structure">)</span><span class="pln" title="PPI::Token::Structure">;</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="pln" title="PPI::Token::Whitespace">    </span><span class="pln" title="PPI::Token::Structure">}</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="pln" title="PPI::Token::Structure">}</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="pln" title="PPI::Token::Whitespace">
</span><span class="dec" title="PPI::Token::Number">1</span><span class="pln" title="PPI::Token::Structure">;</span><span class="pln" title="PPI::Token::Whitespace">
</span></pre>!;

# TESTS

ok( $expectedOutput eq prettify( { code => $code } ), 'Test expected output' );
ok( $expectedDebugOutput eq prettify( { code => $code, debug => 1 } ),
    'Test expected debug output' );

eval { prettify() };
ok( $@, 'Test failure on missing code arg' );

use Data::Dumper;

my @tokens = $doc->tokens;

ok( $tokens[0]->isa('PPI::Token::Comment'),     'Token tree starting type' );
ok( $tokens[99]->isa('PPI::Token::Whitespace'), 'Token tree ending type' );
ok( 'PPI::Token::Function' eq PPI::Prettify::_determineToken( $tokens[66] ),
    '_decorate identifies foreach as a keyword type' );
ok( 'PPI::Token::Word' eq PPI::Prettify::_determineToken( $tokens[84] ),
    '_decorate identifies _toHTML as a word type' );

done_testing();

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
