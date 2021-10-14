--
-- m o n o t o n e
--
--
-- Copyright 2021 Kim Silkebækken
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to
-- deal in the Software without restriction, including without limitation the
-- rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
-- sell copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
-- FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.
--
--
-- Lua configuration example:
--
--   vim.g.monotone_h = 85
--   vim.g.monotone_s = 30
--   vim.g.monotone_l = 50
--   vim.g.monotone_contrast = 100
--   vim.g.monotone_true_monotone = true
--   vim.o.background = 'light'
--

local lush = require("lush")
local hsl = lush.hsl

-- Config options
local opt = {
	bg = vim.o.background,
	color = hsl(tonumber(vim.g.monotone_h) or 15, tonumber(vim.g.monotone_s) or 5, (tonumber(vim.g.monotone_l) or 50)),
	contrast = (tonumber(vim.g.monotone_contrast) or 100) / 100,
	true_monotone = vim.g.monotone_true_monotone or false,
}

-- Handle dark/light background color
local offset_fn = "lighten"
if opt.bg == "light" then
	opt.color = opt.color.darken(50)
	offset_fn = "darken"
end

-- Monochrome shades
local shade = function(color, offset)
	return color[offset_fn](offset * opt.contrast)
end
local s = { 50, 20, 10, 0, -10, -25, -45, -60, inv = -100, normal = 100 }
for k, v in pairs(s) do
	s[k] = shade(opt.color, v)
end

-- Highlight colors
local red = shade(hsl(2, 100, s.normal.l), -35)
local yellow = shade(hsl(32, 100, s.normal.l), -35)
local blue = shade(hsl(205, 85, s.normal.l), -35)
local green = shade(hsl(90, 40, s.normal.l), -35)
local eob = shade(hsl(240, 30, s.normal.l), -45)
local nt = shade(hsl(330, 30, s.normal.l), -50)

if opt.true_monotone then
	-- Disable all colors
	red = s[3]
	yellow = s[2]
	blue = s[1]
	green = s[4]
	eob = s[4]
	nt = s[4]
end

local hl1 = red
local hl2 = yellow
local hl3 = blue

return lush(function()
	return {
		Normal({ fg = s.normal, bg = s.inv }), -- Normal text

		SyntaxError({ sp = red, gui = "undercurl" }),
		SyntaxWarning({ sp = yellow, gui = "undercurl" }),
		SyntaxInfo({ sp = blue, gui = "undercurl" }),
		SyntaxHint({ sp = green, gui = "undercurl" }),

		Comment({ fg = s[6], gui = "italic" }), -- any comment
		ColorColumn({ bg = s[6] }), -- used for the columns set with 'colorcolumn'
		Conceal({}), -- placeholder characters substituted for concealed text (see 'conceallevel')
		Cursor({ bg = hl1 }), -- character under the cursor
		CursorI({ bg = hl1 }), -- insert cursor TODO make this based on other colors
		CursorR({ bg = hl2 }), -- replace cursor
		CursorO({ bg = hl3 }), -- operator-pending cursor
		-- lCursor      { }, -- the character under the cursor when |language-mapping| is used (see 'guicursor')
		-- CursorIM     { }, -- like Cursor, but used when in IME mode |CursorIM|
		-- CursorColumn { }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
		CursorLine({ bg = Normal.bg[offset_fn](5) }), -- Screen-line at the cursor, when 'cursorline' is set.  Low-priority if foreground (ctermfg OR guifg) is not set.
		Directory({}), -- directory names (and other special names in listings)
		DiffAdd({ fg = green }), -- diff mode: Added line |diff.txt|
		DiffChange({ fg = yellow }), -- diff mode: Changed line |diff.txt|
		DiffDelete({ fg = red }), -- diff mode: Deleted line |diff.txt|
		DiffText({ fg = s.inv, bg = red }), -- diff mode: Changed text within a changed line |diff.txt|
		EndOfBuffer({ fg = eob }), -- filler lines (~) after the end of the buffer.  By default, this is highlighted like |hl-NonText|.
		-- TermCursor   { }, -- cursor in a focused terminal
		-- TermCursorNC { }, -- cursor in an unfocused terminal
		Error({ fg = hl1, gui = "bold" }), -- (preferred) any erroneous construct
		ErrorMsg({ Error }), -- error messages on the command line
		VertSplit({ fg = s[1] }), -- the column separating vertically split windows
		Folded({ fg = s.normal, bg = s[5], gui = "italic" }), -- line used for closed folds
		FoldColumn({}), -- 'foldcolumn'
		SignColumn({}), -- column where |signs| are displayed
		IncSearch({ fg = s.inv, bg = hl3 }), -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
		Substitute({}), -- |:substitute| replacement text highlighting
		LineNr({ fg = s[1] }), -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
		CursorLineNr({ fg = s[1] }), -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
		MatchParen({ fg = s.inv, bg = hl2 }), -- The character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
		ParenMatch({ MatchParen }),
		ModeMsg({}), -- 'showmode' message (e.g., "-- INSERT -- ")
		MsgArea({}), -- Area for messages and cmdline
		MsgSeparator({}), -- Separator for scrolled messages, `msgsep` flag of 'display'
		MoreMsg({ fg = hl3, gui = "bold" }), -- |more-prompt|
		NonText({ fg = nt }), -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
		NormalFloat({}), -- Normal text in floating windows.
		NormalNC({}), -- Normal text in non-current windows
		Pmenu({ fg = s[1], bg = s[8] }), -- Popup menu: Normal item.
		PmenuSel({ fg = s.inv, bg = s.normal }), -- Popup menu: selected item.
		PmenuSbar({ bg = s[8] }), -- Popup menu: scrollbar.
		PmenuThumb({ bg = s[3] }), -- Popup menu: Thumb of the scrollbar.
		Question({}), -- |hit-enter| prompt and yes/no questions
		QuickFixLine({}), -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
		Search({ fg = s.inv, bg = hl2 }), -- Last search pattern highlighting (see 'hlsearch').  Also used for similar items that need to stand out.
		SpecialKey({ gui = "bold" }), -- Unprintable characters: text displayed differently from what it really is.  But not 'listchars' whitespace. |hl-Whitespace|
		SpellBad({ SyntaxError }), -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
		SpellCap({ SyntaxInfo }), -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
		SpellLocal({ SyntaxHint }), -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
		SpellRare({ SyntaxWarning }), -- Word that is recognized by the spellchecker as one that is hardly ever used.  |spell| Combined with the highlighting used otherwise.
		StatusLine({ fg = s[1], gui = "underline" }), -- status line of current window
		StatusLineNC({ fg = s[3], gui = "underline" }), -- status lines of not-current windows Note: if this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
		TabLine({ fg = s[3] }), -- tab pages line, not active tab page label
		TabLineFill({ fg = s[3] }), -- tab pages line, where there are no labels
		TabLineSel({ fg = s[1], gui = "bold" }), -- tab pages line, active tab page label
		Title({ gui = "bold" }), -- titles for output from ":set all", ":autocmd" etc.
		Visual({ fg = s.inv, bg = s.normal }), -- Visual mode selection
		VisualNOS({}), -- Visual mode selection when vim is "Not Owning the Selection".
		Warning({ fg = hl2, gui = "bold" }), -- warning messages
		WarningMsg({ Warning }), -- warning messages
		Whitespace({ fg = s[7] }), -- "nbsp", "space", "tab" and "trail" in 'listchars'
		WildMenu({ fg = s[6], fg = s.normal }), -- current match in 'wildmenu' completion

		Constant({}), -- (preferred) any constant
		String({ fg = s[2] }), --   a string constant: "this is a string"
		Character({}), --  a character constant: 'c', '\n'
		Number({}), --   a number constant: 234, 0xff
		Boolean({ gui = "italic" }), --  a boolean constant: TRUE, false
		Float({}), --    a floating point constant: 2.3e10

		Identifier({ gui = "italic" }), -- (preferred) any variable name
		Function({ gui = "bold" }), -- function name (also: methods for classes)

		Statement({ gui = "bold,italic" }), -- (preferred) any statement
		Conditional({}), --  if, then, else, endif, switch, etc.
		Repeat({}), --   for, do, while, etc.
		Label({}), --    case, default, etc.
		Operator({}), -- "sizeof", "+", "*", etc.
		Keyword({}), --  any other keyword
		Exception({}), --  try, catch, throw

		PreProc({}), -- (preferred) generic Preprocessor
		Include({ gui = "italic" }), --  preprocessor #include
		Define({}), --   preprocessor #define
		Macro({}), --    same as Define
		PreCondit({}), --  preprocessor #if, #else, #endif, etc.

		Type({ gui = "bold" }), -- (preferred) int, long, char, etc.
		StorageClass({}), -- static, register, volatile, etc.
		Structure({}), --  struct, union, enum, etc.
		Typedef({}), --  A typedef

		Special({}), -- (preferred) any special symbol
		SpecialChar({}), --  special character in a constant
		Tag({}), --    you can use CTRL-] on this
		Delimiter({ fg = s[1] }), --  character that needs attention
		SpecialComment({}), -- special things inside a comment
		Debug({}), --    debugging statements

		Underlined({ gui = "underline" }), -- (preferred) text that stands out, HTML links
		Bold({ gui = "bold" }),
		Italic({ gui = "italic" }),

		-- Ignore         { }, -- (preferred) left blank, hidden  |hl-Ignore|

		Todo({ fg = hl2, gui = "bold,italic" }), -- (preferred) anything that needs extra attention; mostly the keywords TODO FIXME and XXX

		-- LspReferenceText                     { }, -- used for highlighting "text" references
		-- LspReferenceRead                     { }, -- used for highlighting "read" references
		-- LspReferenceWrite                    { }, -- used for highlighting "write" references

		DiagnosticError({ fg = red, bg = shade(red, -78) }), -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		DiagnosticWarn({ fg = yellow, bg = shade(yellow, -78) }), -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		DiagnosticInfo({ fg = blue, bg = shade(blue, -78) }), -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)
		DiagnosticHint({ fg = green, bg = shade(green, -78) }), -- Used as the base highlight group. Other LspDiagnostic highlights link to this by default (except Underline)

		-- LspDiagnosticsVirtualTextError       { }, -- Used for "Error" diagnostic virtual text
		-- LspDiagnosticsVirtualTextWarning     { }, -- Used for "Warning" diagnostic virtual text
		-- LspDiagnosticsVirtualTextInformation { }, -- Used for "Information" diagnostic virtual text
		-- LspDiagnosticsVirtualTextHint        { }, -- Used for "Hint" diagnostic virtual text

		DiagnosticUnderlineError({ SyntaxError }), -- Used to underline "Error" diagnostics
		DiagnosticUnderlineWarn({ SyntaxWarning }), -- Used to underline "Warning" diagnostics
		DiagnosticUnderlineInfo({ SyntaxInfo }), -- Used to underline "Information" diagnostics
		DiagnosticUnderlineHint({ SyntaxHint }), -- Used to underline "Hint" diagnostics

		-- LspDiagnosticsFloatingError          { }, -- Used to color "Error" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingWarning        { }, -- Used to color "Warning" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingInformation    { }, -- Used to color "Information" diagnostic messages in diagnostics float
		-- LspDiagnosticsFloatingHint           { }, -- Used to color "Hint" diagnostic messages in diagnostics float

		DiagnosticSignError({ fg = red, bg = shade(red, -78) }), -- Used for "Error" signs in sign column
		DiagnosticSignWarning({ fg = yellow, bg = shade(yellow, -78) }), -- Used for "Warning" signs in sign column
		DiagnosticSignInformation({ fg = blue, bg = shade(blue, -78) }), -- Used for "Information" signs in sign column
		DiagnosticSignHint({ fg = green, bg = shade(green, -78) }), -- Used for "Hint" signs in sign column

		-- TSAnnotation         { };    -- For C++/Dart attributes, annotations that can be attached to the code to denote some kind of meta information.
		-- TSAttribute          { };    -- (unstable) TODO: docs
		-- TSBoolean            { };    -- For booleans.
		-- TSCharacter          { };    -- For characters.
		-- TSComment            { };    -- For comment blocks.
		-- TSConstructor        { };    -- For constructor calls and definitions: ` { }` in Lua, and Java constructors.
		-- TSConditional        { };    -- For keywords related to conditionnals.
		TSConstant({ gui = "underline" }), -- For constants
		-- TSConstBuiltin       { };    -- For constant that are built in the language: `nil` in Lua.
		-- TSConstMacro         { };    -- For constants that are defined by macros: `NULL` in C.
		-- TSError              { };    -- For syntax/parser errors.
		-- TSException          { };    -- For exception related keywords.
		-- TSField              { };    -- For fields.
		-- TSFloat              { };    -- For floats.
		-- TSFunction           { };    -- For function (calls and definitions).
		-- TSFuncBuiltin        { };    -- For builtin functions: `table.insert` in Lua.
		-- TSFuncMacro          { };    -- For macro defined fuctions (calls and definitions): each `macro_rules` in Rust.
		-- TSInclude            { };    -- For includes: `#include` in C, `use` or `extern crate` in Rust, or `require` in Lua.
		-- TSKeyword            { };    -- For keywords that don't fall in previous categories.
		-- TSKeywordFunction    { };    -- For keywords used to define a fuction.
		-- TSLabel              { };    -- For labels: `label:` in C and `:label:` in Lua.
		-- TSMethod             { };    -- For method calls and definitions.
		-- TSNamespace          { };    -- For identifiers referring to modules and namespaces.
		-- TSNone               { };    -- TODO: docs
		-- TSNumber             { };    -- For all numbers
		-- TSOperator           { };    -- For any operator: `+`, but also `->` and `*` in C.
		-- TSParameter          { };    -- For parameters of a function.
		-- TSParameterReference { };    -- For references to parameters of a function.
		TSProperty({ gui = "italic" }), -- Same as `TSField`.
		-- TSPunctDelimiter     { };    -- For delimiters ie: `.`
		-- TSPunctBracket       { };    -- For brackets and parens.
		-- TSPunctSpecial       { };    -- For special punctutation that does not fall in the catagories before.
		-- TSRepeat             { };    -- For keywords related to loops.
		-- TSString             { };    -- For strings.
		TSStringRegex({ fg = s[1], gui = "italic" }), -- For regexes.
		TSStringEscape({ fg = s.normal, gui = "bold" }), -- For escape characters within a string.
		-- TSSymbol             { };    -- For identifiers referring to symbols or atoms.
		-- TSType               { };    -- For types.
		-- TSTypeBuiltin        { };    -- For builtin types.
		-- TSVariable           { };    -- Any variable name that does not have another highlight.
		-- TSVariableBuiltin    { };    -- Variable names that are defined by the languages, like `this` or `self`.

		-- TSTag                { };    -- Tags like html tag names.
		-- TSTagDelimiter       { };    -- Tag delimiter like `<` `>` `/`
		-- TSText               { };    -- For strings considered text in a markup language.
		-- TSEmphasis           { };    -- For text to be represented with emphasis.
		-- TSUnderline          { };    -- For text to be represented with an underline.
		-- TSStrike             { };    -- For strikethrough text.
		-- TSTitle              { };    -- Text that is part of a title.
		-- TSLiteral            { };    -- Literal text.
		-- TSURI                { };    -- Any URI like a link or email.
	}
end)
