# Terraform Cloud CDN

Ce module permet de créer un CDN sur Google Cloud via terraform.

## Fonctionnalités du module

Ce module crée : 

- un bucket Cloud Storage en mode website qui doit rediriger toutes requêtes vers index.html (les fichiers doivent être uploadés manuellement dans le bucket)
- un Cloud CDN qui a pour backend le bucket
- un HTTPS load balancer qui utilisera le bucket comme backend (avec un certificat SSL managé par GCP)
- un DNS qui pointera en Alias vers ce loadbalancer
- un HTTP loadbalancer qui fait la redirection HTTP vers HTTPS

## Utilisation du module
