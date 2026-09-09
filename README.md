# Pharmacy PMS Backend Deployment

This folder describes the production backend deployment for the mobile/web client.

## Recommended deployment

Deploy `src/backend_csharp` with its Dockerfile to Render or Railway.
The service must expose the port provided by the `PORT` environment variable.

Required environment variables:

```text
ASPNETCORE_ENVIRONMENT=Production
DATABASE_URL=<managed PostgreSQL connection string>
Jwt__Key=<long random secret, at least 32 characters>
AllowedHosts=*
```

The backend URL should be:

```text
https://api.your-domain.com
```

The frontend/mobile web build must use:

```text
VITE_API_BASE_URL=https://api.your-domain.com
```

The application automatically appends `/api`, so do not set the value to
`https://api.your-domain.com/api`.

## Render

Use the repository `render.yaml` or create a Docker web service with:

```text
Dockerfile: src/backend_csharp/Dockerfile
Docker context: src/backend_csharp
```

Attach a managed PostgreSQL database and map its connection string to
`DATABASE_URL`.

## Railway

Deploy from the repository. Railway detects `railway.json` and uses:

```text
src/backend_csharp/Dockerfile
```

Add `DATABASE_URL` from the PostgreSQL plugin and add `Jwt__Key` manually.

## Direct ASP.NET hosting

The `publish` folder is a self-contained framework-dependent deployment for
.NET 8. Install the .NET 8 ASP.NET Core Runtime on the server and run:

```powershell
dotnet PharmacyApi.dll
```

Set `PORT`, `DATABASE_URL`, `Jwt__Key`, and `AllowedHosts` in the server
environment. Put HTTPS in front of Kestrel using the hosting provider or a
reverse proxy.

## Verification

After deployment, verify:

```text
GET https://api.your-domain.com/api/license/machine-id
POST https://api.your-domain.com/api/auth/login
```

Do not upload `private.pem`, `tools/license-generator/keys`, local SQLite files,
`bin`, `obj`, or customer desktop license files to the public API server.
