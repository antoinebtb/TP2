# Utiliser l'image PostgreSQL officielle comme base
FROM postgres:14.1-alpine

# Copier les scripts SQL dans le conteneur
COPY ./sql-scripts /docker-entrypoint-initdb.d

# Définir les variables d'environnement par défaut pour la connexion à la base de données
ENV POSTGRES_DB=db \
    POSTGRES_USER=usr \
    POSTGRES_PASSWORD=pwd

    