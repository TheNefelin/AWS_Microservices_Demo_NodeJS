# --------- STAGE 1: Build ----------
FROM node:20 AS build
WORKDIR /app

# Copiamos package.json y lock primero (para aprovechar la cache de Docker)
COPY package*.json ./

# Instalamos dependencias (con --only=production eliminamos devDependencies)
RUN npm install --only=production

# Copiamos el resto del código
COPY . .

# --------- STAGE 2: Runtime ----------
FROM node:20-slim AS runtime
WORKDIR /app

# Copiamos solo lo necesario desde la build
COPY --from=build /app /app

# Exponer el puerto
EXPOSE 3000

# Ejecutar app
CMD ["node", "app.js"]
