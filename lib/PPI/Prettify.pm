package PPI::Prettify;
use strict;
use warnings;

# ABSTRACT: A Perl HTML pretty printer to use with Google prettify CSS skins, no JavaScript required!

BEGIN {
    require Exporter;
    use base qw(Exporter);
    our @EXPORT = qw(prettify $MARKUP_RULES);
}

use PPI::Document;
use Carp 'croak';

# A regex of all Perl built-in function names
my $FUNCTIONSREGEX =
  qr/^(AUTOLOAD|abs|accept|alarm|and|atan2|BEGIN|bind|binmode|bless|break|CHECK|caller|chdir|chmod|chomp|chop|chown|chr|chroot|close|closedir|cmp|connect|continue|cos|crypt|DESTROY|__DATA__|dbmclose|dbmopen|default|defined|delete|die|do|dump|END|__END__|each|else|elseif|elsif|endgrent|endhostent|endnetent|endprotoent|endpwent|endservent|eof|eq|eval|evalbytes|exec|exists|exit|exp|__FILE__|fc|fcntl|fileno|flock|for|foreach|fork|format|formline|ge|getc|getgrent|getgrgid|getgrnam|gethostbyaddr|gethostbyname|gethostent|getlogin|getnetbyaddr|getnetbyname|getnetent|getpeername|getpgrp|getppid|getpriority|getprotobyname|getprotobynumber|getprotoent|getpwent|getpwnam|getpwuid|getservbyname|getservbyport|getservent|getsockname|getsockopt|given|glob|gmtime|goto|grep|gt|hex|INIT|if|import|index|int|ioctl|join|keys|kill|__LINE__|last|lc|lcfirst|le|length|link|listen|local|localtime|lock|log|lstat|lt|m|map|mkdir|msgctl|msgget|msgrcv|msgsnd|my|ne|next|no|not|oct|open|opendir|or|ord|our|__PACKAGE__|pack|package|pipe|pop|pos|print|printf|prototype|push|q|qq|qr|quotemeta|qw|qx|rand|read|readdir|readline|readlink|readpipe|recv|redo|ref|rename|require|reset|return|reverse|rewinddir|rindex|rmdir|__SUB__|s|say|scalar|seek|seekdir|select|semctl|semget|semop|send|setgrent|sethostent|setnetent|setpgrp|setpriority|setprotoent|setpwent|setservent|setsockopt|shift|shmctl|shmget|shmread|shmwrite|shutdown|sin|sleep|socket|socketpair|sort|splice|split|sprintf|sqrt|srand|stat|state|study|sub|substr|symlink|syscall|sysopen|sysread|sysseek|system|syswrite|tell|telldir|tie|tied|time|times|tr|truncate|UNITCHECK|uc|ucfirst|umask|undef|unless|unlink|unpack|unshift|untie|until|use|utime|values|vec|wait|waitpid|wantarray|warn|when|while|write|-X|x|xor|y)$/x;

# The mapping of PPI::Token class to span attribute type. Is exported and overridable
our $MARKUP_RULES = {
    'PPI::Token::Whitespace'            => 'pln',
    'PPI::Token::Comment'               => 'com',
    'PPI::Token::Pod'                   => 'com',
    'PPI::Token::Number'                => 'dec',
    'PPI::Token::Number::Binary'        => 'dec',
    'PPI::Token::Number::Octal'         => 'dec',
    'PPI::Token::Number::Hex'           => 'dec',
    'PPI::Token::Number::Float'         => 'dec',
    'PPI::Token::Number::Exp'           => 'dec',
    'PPI::Token::Number::Version'       => 'dec',
    'PPI::Token::Word'                  => 'atn',
    'PPI::Token::Function'              => 'kwd',
    'PPI::Token::DashedWord'            => 'type',
    'PPI::Token::Symbol'                => 'typ',
    'PPI::Token::Magic'                 => 'typ',
    'PPI::Token::ArrayIndex'            => 'lit',
    'PPI::Token::Operator'              => 'pln',
    'PPI::Token::Quote'                 => 'str',
    'PPI::Token::Quote::Single'         => 'str',
    'PPI::Token::Quote::Double'         => 'str',
    'PPI::Token::Quote::Literal'        => 'str',
    'PPI::Token::Quote::Interpolate'    => 'str',
    'PPI::Token::QuoteLike'             => 'str',
    'PPI::Token::QuoteLike::Backtick'   => 'pun',
    'PPI::Token::QuoteLike::Command'    => 'fun',
    'PPI::Token::QuoteLike::Regexp'     => 'str',
    'PPI::Token::QuoteLike::Words'      => 'str',
    'PPI::Token::QuoteLike::Readline'   => 'str',
    'PPI::Token::Regexp'                => 'lit',
    'PPI::Token::Regexp::Match'         => 'lit',
    'PPI::Token::Regexp::Substitute'    => 'lit',
    'PPI::Token::Regexp::Transliterate' => 'lit',
    'PPI::Token::HereDoc'               => 'com',
    'PPI::Token::Cast'                  => 'fun',
    'PPI::Token::Structure'             => 'pln',
    'PPI::Token::Label'                 => 'lit',
    'PPI::Token::Separator'             => 'pun',
    'PPI::Token::Data'                  => 'lit',
    'PPI::Token::End'                   => 'lit',
    'PPI::Token::Prototype'             => 'fun',
    'PPI::Token::Attribute'             => 'var',
    'PPI::Token::Unknown'               => 'pln',
};

sub prettify {
    my $args = shift;
    croak "Missing mandatory code argument in args passed to prettify()."
      unless exists $args->{code} and defined $args->{code};
    my $doc = eval { return PPI::Document->new( \$args->{code} ) };
    croak $@ if $@;
    croak "Error creating PPI::Document" unless $doc;
    return _decorate( $doc, $args->{debug} || 0 );
}

sub _decorate {
    my $prettyPrintedCode = '<pre class="prettyprint">';
    foreach my $token ( $_[0]->tokens ) {
        $prettyPrintedCode .= _toHTML( $token, $_[1] );
    }
    return $prettyPrintedCode .= '</pre>';
}

sub _toHTML {
    my ( $token, $debug ) = @_;
    my $type  = _determineToken($token);
    my $title = "";
    $title = qq( title="$type") if $debug;
    return
        qq(<span class="$MARKUP_RULES->{$type}"$title>)
      . $token->content
      . qq(</span>);
}

sub _determineToken {
    my $token = shift;
    if (    $token->isa('PPI::Token::Word')
        and $token->content =~ $FUNCTIONSREGEX )
    {
        return 'PPI::Token::Function';
    }
    return ref($token);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

PPI::Prettify - A Perl HTML pretty printer to use with Google prettify CSS
skins, no JavaScript required!

=head1 VERSION

version 0.02

=head1 SYNOPSIS

    use PPI::Prettify 'prettify';

    my $codeSample = q! # get todays date in Perl
                        use Time::Piece;
                        print Time::Piece->new;
                      !;

    my $html = prettify({ code => $codeSample });

    # every Perl token wrapped in a span e.g. for "use PPI::Prettify;":
        <span class="kwd">use</span>
        <span class="pln"> </span>
        <span class="atn">PPI::Prettify</span>
        <span class="pln">;</span>

    my $htmlDebug = prettify({ code => $codeSample, debug => 1 }); 
    # with PPI::Token class, e.g. for "use PPI::Prettify;":
        <span class="kwd" title="PPI::Token::Function">use</span>
        <span class="pln" title="PPI::Token::Whitespace"> </span>
        <span class="atn" title="PPI::Token::Word">PPI::Prettify</span>
        <span class="pln" title="PPI::Token::Structure">;</span>

=head1 DESCRIPTION

This module takes a string Perl code sample and returns the tokens of the code
surrounded with <span> tags. The class attributes are the same used by the
L<prettify.js|https://code.google.com/p/google-code-prettify/>. Using
L<PPI::Prettify> you can generate the prettified code for use in webpages
without using JavaScript but you can use all L<the CSS
skins|https://google-code-prettify.googlecode.com/svn/trunk/styles/index.html>
developed for prettify.js. Also, because this module uses L<PPI::Document> to
tokenize the code, it's more accurate than prettify.js.

L<PPI::Prettify> exports prettify() and the $MARKUP_RULES hashref which is used
to match PPI::Token classes to the class attribute given to that token's <span>
tag. You can modify $MARKUP_RULES to tweak the mapping if you require it.

=head1 MOTIVATION

I wanted to generate marked-up Perl code without using JavaScript for
L<PerlTricks.com|http://perltricks.com>. I was dissatisfied with prettify.js as
it doesn't always tokenize Perl correctly and won't run if the user has
disabled JavaScript. I considered L<PPI::HTML> but it embeds the CSS in the
generated code, and I wanted to use the same markup class attributes as
prettify.js so I could reuse the existing CSS developed for it.

=head1 BUGS AND LIMITATIONS

=over

=item *

This module does not yet process Perl code samples with heredocs correctly.

=item *

Line numbering needs to be added.

=back

=head1 SUBROUTINES/METHODS

=head2 prettify

Takes a hashref consisting of $code and an optional debug flag. Every Perl code
token is given a <span> tag that corresponds to the tags used by Google's
prettify.js library. If debug => 1, then every token's span tag will be given a
title attribute with the value of the originating PPI::Token class. This can
help if you want to override the mappings in $MARKUP_RULES. See L</SYNOPSIS>
for examples.

=head1 INTERNAL FUNCTIONS

=head2 _decorate

Iterates through the tokens of a L<PPI::Document>, marking up each token with a
<span> tag.

=head2 _toHTML

Marks up a token with a span tag with the appropriate class attribute and the
PPI::Token class.

=head2 _determineToken

Determines the PPI::Token type.

=head1 THANKS

Thanks to Adam Kennedy for developing L<PPI::Document>, without which this
module would not be possible.

=head1 SEE ALSO

L<PPI::HTML> is another prettifier for Perl code samples that allows the
embedding of CSS directly into the HTML generation.

=head1 AUTHOR

David Farrell <sillymoos@cpan.org> L<PerlTricks.com|http://perltricks.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by David Farrell.

This is free software; you can redistribute it and/or modify it under the same
terms as the Perl 5 programming language system itself.

=cut
