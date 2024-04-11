-- TP1 fichier réponse -- Modifiez le nom du fichier en suivant les instructions
-- Votre nom: Salhi Zakaria                       Votre DA: 2336054
--ASSUREZ VOUS DE LA BONNE LISIBILITÉ DE VOS REQUÊTES  /5--

-- 1.   Rédigez la requête qui affiche la description pour les trois tables. Le nom des champs et leur type. /2
-- Cette requête est spécifique à Oracle et retournera une erreur si exécutée dans MySQL
SELECT column_name, data_type 
FROM user_tab_columns 
WHERE table_name = 'OUTILS_USAGER';
SELECT column_name, data_type 
FROM user_tab_columns 
WHERE table_name = 'OUTILS_OUTIL';
SELECT column_name, data_type 
FROM user_tab_columns 
WHERE table_name = 'OUTILS_EMPRUNT';

-- 2.   Rédigez la requête qui affiche la liste de tous les usagers, sous le format prénom « espace » nom de famille (indice : concaténation). /2
SELECT PRENOM || ' ' || NOM_FAMILLE 
AS Nom_Complet 
FROM OUTILS_USAGER;




-- 3.   Rédigez la requête qui affiche le nom des villes où habitent les usagers, en ordre alphabétique, le nom des villes va apparaître seulement une seule fois. /2
SELECT DISTINCT VILLE 
FROM OUTILS_USAGER 
ORDER BY VILLE;


-- 4.   Rédigez la requête qui affiche toutes les informations sur tous les outils en ordre alphabétique sur le nom de l’outil puis sur le code. /2
SELECT * 
FROM OUTILS_OUTIL 
ORDER BY NOM, CODE_OUTIL;




-- 5.   Rédigez la requête qui affiche le numéro des emprunts qui n’ont pas été retournés. /2
SELECT NUM_EMPRUNT 
FROM OUTILS_EMPRUNT 
WHERE DATE_RETOUR IS NULL;




-- 6.   Rédigez la requête qui affiche le numéro des emprunts faits avant 2014./3
SELECT NUM_EMPRUNT 
FROM OUTILS_EMPRUNT 
WHERE EXTRACT(YEAR FROM DATE_EMPRUNT) < 2014;




-- 7.   Rédigez la requête qui affiche le nom et le code des outils dont la couleur début par la lettre « j » (indice : utiliser UPPER() et LIKE) /3
SELECT NOM, CODE_OUTIL 
FROM OUTILS_OUTIL 
WHERE UPPER(CARACTERISTIQUES) LIKE 'J%';



-- 8.   Rédigez la requête qui affiche le nom et le code des outils fabriqués par Stanley. /2
SELECT NOM, CODE_OUTIL 
FROM OUTILS_OUTIL 
WHERE FABRICANT = 'Stanley';


-- 9.   Rédigez la requête qui affiche le nom et le fabricant des outils fabriqués de 2006 à 2008 (ANNEE). /2
SELECT NOM, FABRICANT 
FROM OUTILS_OUTIL 
WHERE ANNEE BETWEEN 2006 AND 2008;



-- 10.  Rédigez la requête qui affiche le code et le nom des outils qui ne sont pas de « 20 volts ». /3
SELECT code_outil , nom
 FROM OUTILS_OUTILS
 WHERE CARACTERISTIQUES != '20 volt';


-- 11.  Rédigez la requête qui affiche le nombre d’outils qui n’ont pas été fabriqués par Makita. /2
SELECT COUNT(*) AS Nombre_Outils 
FROM OUTILS_OUTIL 
WHERE FABRICANT != 'Makita';





-- 12.  Rédigez la requête qui affiche les emprunts des clients de Vancouver et Regina. Il faut afficher le nom complet de l’usager, le numéro d’emprunt, la durée de l’emprunt et le prix de l’outil (indice : n’oubliez pas de traiter le NULL possible (dans les dates et le prix) et utilisez le IN). /5
SELECT u.PRENOM || ' ' || u.NOM_FAMILLE AS Nom_Complet, e.NUM_EMPRUNT, e.DATE_EMPRUNT, e.DATE_RETOUR, o.PRIX
FROM OUTILS_EMPRUNT e
INNER JOIN OUTILS_USAGER u ON e.NUM_USAGER = u.NUM_USAGER
INNER JOIN OUTILS_OUTIL o ON e.CODE_OUTIL = o.CODE_OUTIL
WHERE u.VILLE IN ('Vancouver', 'Regina');


-- 13.  Rédigez la requête qui affiche le nom et le code des outils empruntés qui n’ont pas encore été retournés. /4
SELECT o.NOM, o.CODE_OUTIL
FROM OUTILS_OUTIL o
INNER JOIN OUTILS_EMPRUNT e ON o.CODE_OUTIL = e.CODE_OUTIL
WHERE e.DATE_RETOUR IS NULL;



-- 14.  Rédigez la requête qui affiche le nom et le courriel des usagers qui n’ont jamais fait d’emprunts. (indice : IN avec sous-requête) /3
SELECT u.PRENOM || ' ' || u.NOM_FAMILLE AS Nom_Complet, u.COURRIEL
FROM OUTILS_USAGER u
WHERE NOT EXISTS (
    SELECT 1
    FROM OUTILS_EMPRUNT e
    WHERE e.NUM_USAGER = u.NUM_USAGER
);



-- 15.  Rédigez la requête qui affiche le code et la valeur des outils qui n’ont pas été empruntés. (indice : utiliser une jointure externe – LEFT OUTER, aucun NULL dans les nombres) /4
SELECT o.CODE_OUTIL, o.PRIX
FROM OUTILS_OUTIL o
WHERE NOT EXISTS (
    SELECT 1
    FROM OUTILS_EMPRUNT e
    WHERE e.CODE_OUTIL = o.CODE_OUTIL
);


-- 16.  Rédigez la requête qui affiche la liste des outils (nom et prix) qui sont de marque Makita et dont le prix est supérieur à la moyenne des prix de tous les outils. Remplacer les valeurs absentes par la moyenne de tous les autres outils. /4
SELECT o.NOM, COALESCE(o.PRIX, (SELECT AVG(PRIX) FROM OUTILS_OUTIL)) AS Prix_Correct
FROM OUTILS_OUTIL o
WHERE o.FABRICANT = 'Makita' 
AND o.PRIX > (SELECT AVG(PRIX) FROM OUTILS_OUTIL);

-- 17.  Rédigez la requête qui affiche le nom, le prénom et l’adresse des usagers et le nom et le code des outils qu’ils ont empruntés après 2014. Triés par nom de famille. /4
SELECT u.PRENOM, u.NOM_FAMILLE, u.ADRESSE, o.NOM, o.CODE_OUTIL
FROM OUTILS_USAGER u
JOIN OUTILS_EMPRUNT e ON u.NUM_USAGER = e.NUM_USAGER
JOIN OUTILS_OUTIL o ON e.CODE_OUTIL = o.CODE_OUTIL
WHERE EXTRACT(YEAR FROM e.DATE_EMPRUNT) > 2014
ORDER BY u.NOM_FAMILLE;

-- 18.  Rédigez la requête qui affiche le nom et le prix des outils qui ont été empruntés plus qu’une fois. /4
SELECT o.NOM, o.PRIX
FROM OUTILS_OUTIL o
WHERE o.CODE_OUTIL IN (
    SELECT e.CODE_OUTIL
    FROM OUTILS_EMPRUNT e
    GROUP BY e.CODE_OUTIL
    HAVING COUNT(*) > 1
);


-- 19.  Rédigez la requête qui affiche le nom, l’adresse et la ville de tous les usagers qui ont fait des emprunts en utilisant : /6

--  Une jointure

--  IN

--  EXISTS
-- Jointure
SELECT DISTINCT u.NOM_FAMILLE, u.ADRESSE, u.VILLE 
FROM OUTILS_USAGER u 
JOIN OUTILS_EMPRUNT e ON u.NUM_USAGER = e.NUM_USAGER;

-- IN
SELECT u.NOM_FAMILLE, u.ADRESSE, u.VILLE 
FROM OUTILS_USAGER u 
WHERE u.NUM_USAGER IN (SELECT e.NUM_USAGER FROM OUTILS_EMPRUNT e);

-- EXISTS
SELECT u.NOM_FAMILLE, u.ADRESSE, u.VILLE 
FROM OUTILS_USAGER u 
WHERE EXISTS (SELECT 1 FROM OUTILS_EMPRUNT e WHERE e.NUM_USAGER = u.NUM_USAGER);

-- 20.  Rédigez la requête qui affiche la moyenne du prix des outils par marque. /3
SELECT FABRICANT, AVG(PRIX) AS Prix_Moyen
FROM OUTILS_OUTIL
GROUP BY FABRICANT;


-- 21.  Rédigez la requête qui affiche la somme des prix des outils empruntés par ville, en ordre décroissant de valeur. /4
SELECT u.VILLE, SUM(o.PRIX) AS Total_Prix
FROM OUTILS_OUTIL o
JOIN OUTILS_EMPRUNT e ON o.CODE_OUTIL = e.CODE_OUTIL
JOIN OUTILS_USAGER u ON e.NUM_USAGER = u.NUM_USAGER
GROUP BY u.VILLE
ORDER BY Total_Prix DESC;


-- 22.  Rédigez la requête pour insérer un nouvel outil en donnant une valeur pour chacun des attributs. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, FABRICANT, CARACTERISTIQUES, ANNEE, PRIX)
VALUES ('AF289', ' Metre', 'Komelon', '2m de long, rouge', 2004, 25);


-- 23.  Rédigez la requête pour insérer un nouvel outil en indiquant seulement son nom, son code et son année. /2
INSERT INTO OUTILS_OUTIL (CODE_OUTIL, NOM, ANNEE)
VALUES ('DW458', 'Pince', 2013);


-- 24.  Rédigez la requête pour effacer les deux outils que vous venez d’insérer dans la table. /2
DELETE FROM OUTILS_OUTIL 
WHERE CODE_OUTIL IN ('AF289', 'DW458');


-- 25.  Rédigez la requête pour modifier le nom de famille des usagers afin qu’ils soient tous en majuscules. /2
UPDATE OUTILS_USAGER 
SET NOM_FAMILLE = UPPER(NOM_FAMILLE);


