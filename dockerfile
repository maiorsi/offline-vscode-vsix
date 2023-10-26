FROM node:14.20.0-bullseye as omnisharp-offline

WORKDIR /app

RUN git clone https://github.com/OmniSharp/omnisharp-vscode.git /app && \
    git checkout v1.26.0 && \
    npm -i && \
    npm_package_engines_vscode="^1.68.1" node ./node_modules/vscode/bin/install && \
    npm run compile && \
    npm run gulp vsix:offline:package && \
    rm -rf node_modules && \
    rm -rf .razor && \
    rm -rf .debugger && \
    rm -rf .omnisharp

FROM ubuntu
COPY --from=omnisharp-offline /app/csharp.1.26.0-linux-x64.vsix ./csharp.1.26.0-linux-x64.vsix
COPY --from=omnisharp-offline /app/csharp.1.26.0-darwin-x64.vsix ./csharp.1.26.0-darwin
COPY --from=omnisharp-offline /app/csharp.1.26.0-win32-x64.vsix ./csharp.1.26.0-win32-x64.vsix