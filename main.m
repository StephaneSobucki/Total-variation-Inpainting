% Instructions:
% 1) Run
% 2) Chargez l'image en cliquant sur "Load image"
% 3) Cliquez sur "Create mask", vous pourrez alors
% dessiner sur l'image du dessous pour créer le masque. Le masque
% représente la zone endommagée que l'on va chercher à corriger avec notre
% algorithme. Vous pouvez choisir l'épaisseur du curseur pour définir votre
% masque
% 4) Vous pouvez choisir de modifier 3 paramètres de l'algorithme 
% d'inpainting: le paramètre de  régularisation lambda (s'il est trop petit 
% le résultat peut être flou, s'il est trop grand la zone peut rester 
% inchangée), la durée totale T et le pas de temps dt.
% 5) Cliquez sur "Inpainting" pour lancer la correction. Lors de
% l'execution de l'Inpainting par la totale variation, vous pourrez voir
% l'image évoluer. Vous pouvez quitter l'execution à tout moment en
% quittant sur "Cancel" dans la fenêtre qui est apparue au début de
% l'exécution.
%
H = TVinpainting_GUI();

