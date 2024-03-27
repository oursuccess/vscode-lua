REM remove publish folder first
REM comment below file/folder(recursively) to publish folder:
REM client/3rd, client/node_modules, client/web, client/package.json
REM images/logo.png
REM server/bin server/doc server/locale server/script server/changelog.md server/debugger.lua server/main.lua
REM server/meta/3rd server/meta/spell server/meta/template
REM changelog.md package.json package.nls.json package.nls.zh-cn.json package.nls.zh-tw.json package.nls.pt-br.json README.md LICENSE

REM start copy files
set "ROOT=%~dp0"
set "TARGET=%~dp0publish/"

rmdir "%TARGET%" /S /Q
mkdir "%TARGET%"

for %%x in (
	client/out/
	client/3rd/
	client/node_modules/
	client/web/
	server/bin/
	server/doc/
	server/locale/
	server/script/
	server/meta/3rd/
	server/meta/spell/
	server/meta/template/
) do (
	robocopy "%ROOT%%%x" "%TARGET%%%x" * /S /E /COPY:DAT /R:0 /W:0 /NP /NFL /NDL /NJH /NJS /NC /NS
)

REM we need to mkdir of images folder
mkdir "%TARGET%images"

for %%x in (
	changelog.md
	package.json
	package.nls.json
	package.nls.zh-cn.json
	package.nls.zh-tw.json
	package.nls.pt-br.json
	README.md
	LICENSE
) do (
	copy "%ROOT%%%x" "%TARGET%%%x"
)

for %%x in (
	package.json
) do (
	robocopy "%ROOT%client/" "%TARGET%client/" %%x
)

for %%x in (
	logo.png
) do (
	robocopy "%ROOT%images/" "%TARGET%images/" %%x
)

for %%x in (
	changelog.md
	debugger.lua
	main.lua
) do (
	robocopy "%ROOT%server/" "%TARGET%server/" %%x
)

REM finish copy files, start publish
cd "%TARGET%"
vsce package -o "./cpl-ls.vsix"