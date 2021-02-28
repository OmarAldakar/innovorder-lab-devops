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

Ce module comporte trois paramètres obligatoires :

 - `project` : l'identifiant du projet google où le CDN sera créé
 - `dns_name` : le nom du dns à créer qui pointe vers le CDN
 - `google_dns_managed_zone_name` : le nom de la zone DNS dans laquelle le DNS devra être créer

Pour lancer ce module, utiliser la commande `terraform init`, suivi de la commande `terraform apply`

Il est alors nécessaire d'uploader manuellement les fichiers du site dans le bucket et d'attendre quelques minutes le temps que GCP crée le certificat SSL. 
