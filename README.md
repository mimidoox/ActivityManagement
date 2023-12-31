# ActivityManagement

## Introduction

Ce projet Flutter combine la gestion d'activités avec l'intelligence artificielle pour générer automatiquement des catégories d'activités à partir d'images. L'intelligence artificielle est alimentée par un modèle entraîné sur un ensemble de données Kaggle contenant plus de 100 images pour chaque catégorie de sport.

## Plateforme de Test

L'application a été testée sur les plateformes suivantes :
- Émulateur Android
- Téléphone Android

## Identifiants de Connexion

Pour tester l'application, utilisez les identifiants suivants :
- Nom d'utilisateur : mimidoox@gmail.com
- Mot de passe : 123456

## État des Lieux des US Développées
#### US#1 : [MVP] Interface de Login

L'interface de login offre une expérience utilisateur fluide avec des champs de saisie sécurisés.

#### US#2 : [MVP] Liste des Activités

Les activités sont présentées de manière claire, avec des détails accessibles au clic. Une navigation par catégorie est également implémentée.

#### US#3 : [MVP] Détail d'une Activité

La page de détail d'une activité affiche des informations essentielles telles que l'image, le titre, la catégorie, le lieu, le nombre minimum de personnes et le prix.

#### US#4 : [MVP] Filtrer sur la Liste des Activités

Les utilisateurs peuvent filtrer la liste des activités par catégorie, offrant une expérience de navigation plus personnalisée.

#### US#5 : [MVP] Profil Utilisateur

Les informations du profil utilisateur sont accessibles et modifiables, avec une déconnexion rapide.

#### US#6 : [IA] Ajouter une Nouvelle Activité

L'ajout d'une nouvelle activité est simplifié avec un formulaire intuitif et la génération automatique de la catégorie par l'IA.

#### US#7 : Laisser Libre Cours à Votre Imagination

Le projet offre une flexibilité pour l'ajout de fonctionnalités supplémentaires, permettant une évolution continue.

### Interface Utilisateur

L'interface utilisateur comprend les fonctionnalités suivantes :
- Page de Connexion à l'aide de FireBase Auth.
- Affichage d'une liste d'activités avec des catégories générées automatiquement.
- En cliquant sur une activité vous aurez son détail
- Filtrage et affichage des activités par catégorie.
- Personnalisation du profil utilisateur avec ajout de photos de profil via une URL.

<img width="487" alt="Screenshot 2023-12-31 at 15 02 51" src="https://github.com/mimidoox/ActivityManagement/assets/118699556/fb53581e-966e-429f-a1b0-ed84561d7108">
<img width="496" alt="Screenshot 2023-12-31 at 15 03 25" src="https://github.com/mimidoox/ActivityManagement/assets/118699556/e7fd8a3c-d066-40ac-8360-246566d14ed3">
<img width="500" alt="Screenshot 2023-12-31 at 16 33 18" src="https://github.com/mimidoox/ActivityManagement/assets/118699556/a15ddabd-3848-4cad-96db-328041267e81">
<img width="494" alt="Screenshot 2023-12-31 at 15 03 47" src="https://github.com/mimidoox/ActivityManagement/assets/118699556/8b526b2e-4e14-48aa-8bee-dcd9b4072003">
<img width="501" alt="Screenshot 2023-12-31 at 15 04 14" src="https://github.com/mimidoox/ActivityManagement/assets/118699556/19d2bae1-967f-4da4-b077-881bf45e0246">
<img width="506" alt="Screenshot 2023-12-31 at 15 04 44" src="https://github.com/mimidoox/ActivityManagement/assets/118699556/4b4edcfa-688a-4014-9987-c7542728d814">
<img width="507" alt="Screenshot 2023-12-31 at 15 05 09" src="https://github.com/mimidoox/ActivityManagement/assets/118699556/65df3707-16ce-4aea-a811-fd1eb4e1c698">

### Simulation

La simulation a été réalisée sur :

- Émulateur Android
  
https://github.com/mimidoox/ActivityManagement/assets/118699556/d7b7a25e-0dc7-471d-93ac-c040ee728354



## Guide pour Lancer la Partie IA

La partie IA fonctionne automatiquement lors de l'ajout d'une nouvelle activité. Lorsque vous ajoutez une activité, le modèle d'intelligence artificielle analyse l'URL de l'image fournie pour générer automatiquement la catégorie de l'activité.

## Prérequis

- Flutter installé sur votre machine.

## Installation

1. Clonez le dépôt :

   ```bash
   git clone https://github.com/mimidoox/ActivityManagement.git


