---
title: Azure Static Web App - Build Production
date: 2023-01-10T00:01:30
layout: single-github
permalink: /2023/01/azure-static-web-app-build-production
categories:
  - azure
tags:
  - azure
  - static web apps
  - storage
  - devops
github_comments_issueid: 30
---

For a side-project I am using <a href="https://docs.microsoft.com/en-us/azure/static-web-apps/overview" target="_blank">Azure Static Web Apps</a> (SWA). They are intended to simplify the deployment and management of serverless applications, ensuring that the frontend and backend is managed by Azure.<br>
While the quickstarts and tutorials are all well-made, there was one area that caught us by surprise.

## How to build a production Angular App

After creating an SWA in the Azure Portal you get access to the GitHub Actions build configuration. Here's the part of ours that is of interest to SWA:

```yaml
- name: Build And Deploy
  id: builddeploy
  uses: Azure/static-web-apps-deploy@v1
  with:
    azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
    repo_token: ${{ secrets.GITHUB_TOKEN }}
    action: "upload"
    # For more information regarding Static Web App workflow configurations, please visit: https://aka.ms/swaworkflowconfig
    app_location: "frontend"
    api_location: "" # we're not using this as we're hosting the backend ourselves on Azure Functions.
    output_location: "dist/application" # Built app content directory
```

This all works, until we integrated <a href="https://auth0.com/" target="_blank">Auth0</a> into our app and needed our frontend to have very different configuration depending on the environment (local or prod, for simplicity's sake).<br>
In an Angular app, by default, environments are managed via files in the `src/environments` directory. When you create your Angular app you'll find an `environment.ts` and an `environment.prod.ts` in there. Once you added all your environment variables there the `ng build` will pick these up automatically.<br>
We assumed that, and maybe this was a stupid assumption to begin with, the pipeline will automatically build `environment.prod.ts`. It did not.

```yaml
- name: Build And Deploy
  id: builddeploy
  uses: Azure/static-web-apps-deploy@v1
  with:
    azure_static_web_apps_api_token: ${{ secrets.AZURE_STATIC_WEB_APPS_API_TOKEN }}
    repo_token: ${{ secrets.GITHUB_TOKEN }}
    action: "upload"
    # For more information regarding Static Web App workflow configurations, please visit: https://aka.ms/swaworkflowconfig
    app_location: "frontend"
    app_build_command: "npm run build-prod"
    api_location: "" # # we're not using this as we're hosting the backend ourselves on Azure Functions.
    output_location: "dist/application" # Built app content directory
```

The `app_build_command` was important here. It tells us to go and add an "npm script" and reference it in this command.

| You cannot add `ng build --configuration=production` directly in here.

Instead, in your `src/package.json` file, find the `scripts` block and add the command in there like so:

```json
"scripts": {
  "ng": "ng",
  "start": "ng serve",
  "build": "ng build",
  "build-prod": "ng build --configuration production",
  "test": "ng test",
  "lint": "ng lint",
  "e2e": "ng e2e"
},
```

This will add the npm script and allows us to reference it in the build pipeline. Et voila, our production app can now use production values.

[![Angular build output in GitHub Actions](/media/2023/01/angular-build.png)](/media/2023/01/angular-build.png)