# ============================================================
# Dockerfile — نظام إدارة الصيدلية (Backend ASP.NET Core 8)
# مجهز ومحسن للنشر الفوري على: Render, Railway, Fly.io, Azure
# ============================================================

# المرحلة 1: البناء (Build)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# نسخ ملف المشروع واستعادة الحزم أولاً (Docker Cache optimization)
COPY ["PharmacyApi.csproj", "./"]
RUN dotnet restore "PharmacyApi.csproj"

# نسخ باقي الكود وبناء النسخة الإنتاجية
COPY . .
RUN dotnet publish "PharmacyApi.csproj" -c Release -o /app/publish /p:UseAppHost=false

# المرحلة 2: بيئة التشغيل الخفيفة (Runtime)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

# نسخ الملفات المنشورة فقط
COPY --from=build /app/publish .

# إعدادات البيئة السحابية الافتراضية
ENV ASPNETCORE_ENVIRONMENT=Production
ENV PORT=5000
EXPOSE 5000

# تشغيل الـ API
ENTRYPOINT ["dotnet", "PharmacyApi.dll"]
