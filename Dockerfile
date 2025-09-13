# Etapa 1 - Build
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app

# Copia pom.xml e baixa dependências (cache)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copia o resto do código e gera o JAR
COPY src ./src
RUN mvn clean package -DskipTests

# Etapa 2 - Runtime
FROM eclipse-temurin:21-jdk
WORKDIR /app

# Copia o JAR da etapa anterior
COPY --from=build /app/target/*.jar app.jar

# Porta exposta (Render usa a variável PORT)
EXPOSE 8080

# Define comando de inicialização
CMD ["java", "-jar", "app.jar"]
