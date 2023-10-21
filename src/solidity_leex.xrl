Definitions.

Abort = abort
Acquires = acquires
As = as
Break = break
Const = const
Continue = continue
Copy = copy
Else = else
False = false
Fun = fun
Friend = friend
If = if
Invariant = invariant
Let = let
Loop = loop
Module = module
Move = move
Native = native
Public = public
Return = return
Script = script
Spec = spec
Struct = struct
True = true
Use = use
While = while
NumberWithSuffix = (u8|u64|u16|u32|u128|u256)
HexNumber = 0x[0-9a-fA-F_]+{NumberWithSuffix}
DecimalNumber = [0-9][0-9_]+{NumberWithSuffix}
ByteString = (x|b)"((\\")|.)+"
NameToken = {Abort}|{Acquires}|{As}|{Break}|{Const}|{Continue}|{Copy}|{Else}|{False}|{Fun}|{Friend}|{If}|{Invariant}|{Let}|{Loop}|{Module}|{Move}|{Native}|{Public}|{Return}|{Script}|{Spec}|{Struct}|{True}|{Use}|{While}
Identifier = [A-Za-z_][a-zA-Z0-9_]+
AmpMut = &mut
AmpAmp = &&
Amp = &
PipePipe = ||
Pipe = |
EqualEqualGreater = ==>
EqualEqual = ==
Equal = =
Exclaim = i
LessEqualEqualGreater = <==>
LessEqual = <=
LessLess = <<
Less = <
GreaterEqual = >=
GreaterGreater = >>
Greater = >
Coloncolon = ::
Colon = :
Percent = %
LParen = (
RParen = )
LBracket = [
RBracket = ]
Star = *
Plus = +
Comma = ,
Minus = -
PeriodPeriod = ..
Period = .
Slash = /
Semicolon = ;
Caret = ^
LBrace = {
RBrace = }
NumSign = #
AtSign = @

Spaces = [\t\s]*
Comment = {Spaces}//.*
SectionComment = {Spaces}/\*.*\*/
EndLine = {Spaces}[\r\n]+
NoneLine = [\r\n]+
IgnoreUse = use.+[\r\n]+
ColoncolonIdetifier = {Identifier}{Coloncolon}{Identifier}
ModuleLine = {Spaces}contract{Spaces}.+{|{Spaces}library{Spaces}.+{
ScriptLine = {Spaces}script{Spaces}.+{
UseLine = {Spaces}use{Spaces}.*{Semicolon}
ConstLine = {Spaces}constructor{Spaces}.+
StructBegin = {Spaces}struct.*{
Struct = {Spaces}struct.*}
CommentStart = {Spaces}/\*.*
CommentEnd = .*\*/
Friend = {Spaces}friend.+
Annotation = {Spaces}#\[.*
FunBegin = {Spaces}(public{Spaces}entry|public|entry|inline){Spaces}function.+|{Spaces}function{Spaces}.+|{Spaces}receive{Spaces}.+
Fun = {Spaces}(public{Spaces}entry|public|entry|inline){Spaces}function.+}|{Spaces}function{Spaces}.+}
LBraceLine = {Spaces}.*{
RBraceLine = {Spaces}}.*
RBraceSemicolon = {Spaces}(}|}\));
LBraceRBrace = {Spaces}}.+{
Pragma = {Spaces}pragma.+
Import = {Spaces}import.+
EnumBegin = {Spaces}enum.+
ModifierBegin = {Spaces}modifier.+
Modifier = {Spaces}modifier.+}
Event = {Spaces}event.+;
Rules.
%% event
{Event} : {token, {event, TokenLine, TokenChars}}.
%% modifier
{Modifier} : {token, {modifier, TokenLine, TokenChars}}.
{ModifierBegin} : {token, {modifier_begin, TokenLine, TokenChars}}.
%% enum 
{EnumBegin} : {token, {enum, TokenLine, TokenChars}}.
%% import
{Import} : {token, {import, TokenLine, TokenChars}}.
%% pragma
{Pragma} : {token, {pragma, TokenLine, TokenChars}}.
{SectionComment} : {token, {comment, TokenLine,  TokenChars}}.
{CommentStart} : {token, {comment_start, TokenLine, TokenChars}}.
{CommentEnd} : {token, {comment_end, TokenLine, TokenChars}}.
{Comment} : {token, {comment, TokenLine, TokenChars}}.
% {Spaces}  : {token, {space, TokenLine, TokenChars}}.
%% module
{ModuleLine} : {token, {module, TokenLine, TokenChars}}.
%% Script
{ScriptLine} : {token, {script, TokenLine, TokenChars}}.
%% use
{UseLine} : {token, {use,  TokenLine, trim(TokenChars)}}.
{ConstLine} : {token, {const, TokenLine, trim(TokenChars)}}.
{Friend} : {token, {friend, TokenLine, trim(TokenChars)}}.
%% struct
{StructBegin} : {token, {struct_begin, TokenLine, trim(TokenChars)}}.
{Struct} : {token, {struct, TokenLine, trim(TokenChars)}}.

%% fuction
{Fun} : {token, {function, TokenLine, trim(TokenChars)}}.
{FunBegin} : {token, {fun_begin, TokenLine, trim(TokenChars)}}.
%% brace
{LBrace} : {token, {lbrace, TokenLine, TokenChars}}.
{Spaces}{RBrace}|{Spaces}{RBrace}\) : {token, {rbrace, TokenLine, parse_brace(TokenChars)}}.
{LBraceRBrace} : {token, {other, TokenLine, TokenChars}}.
{LBraceLine} : {token, {lbrace_line, TokenLine, TokenChars}}.
{RBraceLine} : {token, {rbrace_line, TokenLine, TokenChars}}.
{RBraceSemicolon} : {token, {rbrace_semicolon, TokenLine, parse_brace(TokenChars)}}.
{Annotation} : {token, {annotation, TokenLine, trim(TokenChars)}}.
{NoneLine} : skip_token.
{Spaces} : skip_token.
.* : {token, {other, TokenLine, TokenChars}}.
\s+ : skip_token.

Erlang code.

parse_module(TokenChars) ->
   R1 = trim(TokenChars),
   trim(R1, leading, "module").

parse_brace(TokenChars) ->
    trim(TokenChars).

otp_ver() ->
    {match, [VerStr]} = re:run(erlang:system_info(otp_release), "^R?([0-9]+)", [{capture,[1],list}]),
    list_to_integer(VerStr).

has_string_trim() ->
    otp_ver() >= 20.

trim(S) -> trim(S, both).
trim(S, D) ->
    case has_string_trim() of
        true -> string:trim(S, D);
        false -> my_trim(S, D, " ")
    end.

trim(S, D, Chars) ->
    case has_string_trim() of
        true -> string:trim(S, D, Chars);
        false -> my_trim(S, D, Chars)
    end.

my_trim([S], D, List) when is_list(S) ->
    my_trim(S, D, List);

my_trim(S, D, [Sep]) ->
    D2 = case D of
        leading -> left;
        trailing -> right;
        both -> both
    end,
    string:strip(S, D2, Sep);
my_trim(S, leading, List) ->
    L = length(List),
    case string:substr(S, 1, L) of
        List -> string:substr(S, L + 1);
        _ -> S
    end.