% Instructions:
% 1) Run
% 2) Chargez l'image en cliquant sur "Load image"
% 3) Cliquez sur "Create mask", vous pourrez alors
% dessiner sur l'image du dessous pour cr�er le masque. Le masque
% repr�sente la zone endommag�e que l'on va chercher � corriger avec notre
% algorithme. Vous pouvez choisir l'�paisseur du curseur pour d�finir votre
% masque
% 4) Vous pouvez choisir de modifier 3 param�tres de l'algorithme 
% d'inpainting: le param�tre de  r�gularisation lambda (s'il est trop petit 
% le r�sultat peut �tre flou, s'il est trop grand la zone peut rester 
% inchang�e), la dur�e totale T et le pas de temps dt.
% 5) Cliquez sur "Inpainting" pour lancer la correction. Lors de
% l'execution de l'Inpainting par la totale variation, vous pourrez voir
% l'image �voluer. Vous pouvez quitter l'execution � tout moment en
% quittant sur "Cancel" dans la fen�tre qui est apparue au d�but de
% l'ex�cution.
%
H = TVinpainting_GUI();

