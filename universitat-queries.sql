-- Base de dades Universidad

-- 1. Retorna un llistat amb el primer cognom, segon cognom i el nom de tots els alumnes. El llistat haurà d'estar ordenat alfabèticament de menor a major pel primer cognom, segon cognom i nom.
SELECT apellido1, apellido2, nombre FROM persona WHERE tipo = 'alumno' order by apellido1, apellido2, nombre;

-- 2 Esbrina el nom i els dos cognoms dels alumnes que no han donat d'alta el seu número de telèfon en la base de dades.
SELECT apellido1, apellido2, nombre FROM persona WHERE tipo = 'alumno' AND telefono IS NULL;

-- 3. Retorna el llistat dels alumnes que van néixer en 1999.
SELECT * FROM persona WHERE tipo = 'alumno' AND fecha_nacimiento BETWEEN '1999-01-01' AND '1999-12-31';

-- 4. Retorna el llistat de professors que no han donat d'alta el seu número de telèfon en la base de dades i a més la seva nif acaba en K.
SELECT * FROM persona WHERE tipo = 'profesor' AND telefono IS NULL AND RIGHT(nif,1) = 'K';

-- 5. Retorna el llistat de les assignatures que s'imparteixen en el primer quadrimestre, en el tercer curs del grau que té l'identificador 7.
SELECT * FROM asignatura WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

-- 6. Retorna un llistat dels professors juntament amb el nom del departament al qual estan vinculats. El llistat ha de retornar quatre columnes, primer cognom, segon cognom, nom i nom del departament. El resultat estarà ordenat alfabèticament de menor a major pels cognoms i el nom.
SELECT apellido1, apellido2, persona.nombre, departamento.nombre FROM persona INNER JOIN profesor ON profesor.id_profesor = persona.id INNER JOIN departamento ON departamento.id = profesor.id_departamento ORDER BY apellido1, apellido2, persona.nombre ;

-- 7. Retorna un llistat amb el nom de les assignatures, any d'inici i any de fi del curs escolar de l'alumne amb nif 26902806M.
SELECT asignatura.nombre, curso_escolar.anyo_inicio, curso_escolar.anyo_fin FROM asignatura INNER JOIN alumno_se_matricula_asignatura al ON al.id_asignatura = asignatura.id INNER JOIN persona ON al.id_alumno = persona.id INNER JOIN curso_escolar ON curso_escolar.id = al.id_curso_escolar WHERE persona.nif = '26902806M';

-- 8. Retorna un llistat amb el nom de tots els departaments que tenen professors que imparteixen alguna assignatura en el Grau en Enginyeria Informàtica (Pla 2015).
SELECT DISTINCT departamento.nombre FROM departamento INNER JOIN profesor ON profesor.id_departamento = departamento.id INNER JOIN asignatura USING(id_profesor) INNER JOIN grado ON grado.id = asignatura.id_grado WHERE grado.nombre = 'Grado en Ingeniería Informática (Plan 2015)';

-- 9. Retorna un llistat amb tots els alumnes que s'han matriculat en alguna assignatura durant el curs escolar 2018/2019.
SELECT DISTINCT apellido1, apellido2, persona.nombre FROM persona INNER JOIN alumno_se_matricula_asignatura al_as ON al_as.id_alumno = persona.id INNER JOIN curso_escolar ON curso_escolar.id = al_as.id_curso_escolar WHERE persona.tipo = 'alumno' AND curso_escolar.anyo_inicio = '2018' AND curso_escolar.anyo_fin = '2019';

-- Resolgui les 6 següents consultes utilitzant les clàusules LEFT JOIN i RIGHT JOIN.
-- 1. Retorna un llistat amb els noms de tots els professors i els departaments que tenen vinculats. El llistat també ha de mostrar aquells professors que no tenen cap departament associat. El llistat ha de retornar quatre columnes, nom del departament, primer cognom, segon cognom i nom del professor. El resultat estarà ordenat alfabèticament de menor a major pel nom del departament, cognoms i el nom.
SELECT departamento.nombre AS 'departamento', apellido1, apellido2, persona.nombre FROM persona JOIN profesor ON persona.id = profesor.id_profesor LEFT JOIN departamento ON departamento.id = profesor.id_departamento ORDER BY departamento.nombre, apellido1, apellido2, persona.nombre;

-- 2. Retorna un llistat amb els professors que no estan associats a un departament.
SELECT apellido1, apellido2, persona.nombre FROM persona LEFT JOIN profesor ON profesor.id_profesor = persona.id WHERE tipo = 'profesor' AND profesor.id_profesor IS NULL;

-- 3. Retorna un llistat amb els departaments que no tenen professors associats.
SELECT departamento.nombre FROM departamento LEFT JOIN profesor ON profesor.id_departamento = departamento.id WHERE profesor.id_departamento IS NULL;

-- 4. Retorna un llistat amb els professors que no imparteixen cap assignatura.
SELECT apellido1, apellido2, persona.nombre FROM persona JOIN profesor ON profesor.id_profesor = persona.id LEFT JOIN asignatura USING(id_profesor) WHERE asignatura.id_profesor IS NULL; 

-- 5. Retorna un llistat amb les assignatures que no tenen un professor assignat.
SELECT asignatura.nombre FROM asignatura LEFT JOIN profesor USING (id_profesor) WHERE profesor.id_profesor IS NULL;

-- 6. Retorna un llistat amb tots els departaments que no han impartit assignatures en cap curs escolar.
SELECT DISTINCT departamento.nombre FROM departamento LEFT JOIN profesor ON departamento.id = profesor.id_departamento LEFT JOIN asignatura USING (id_profesor) WHERE asignatura.id_profesor IS NULL or profesor.id_departamento IS NULL;

-- Consultes resum:
-- 1. Retorna el nombre total d'alumnes que hi ha.
SELECT count(id) FROM persona WHERE tipo = 'alumno';

-- 2. Calcula quants alumnes van néixer en 1999.
SELECT count(id) FROM persona WHERE tipo = 'alumno' AND fecha_nacimiento BETWEEN '1999-01-01' AND '1999-12-31';

-- 3. Calcula quants professors hi ha en cada departament. El resultat només ha de mostrar dues columnes, una amb el nom del departament i una altra amb el nombre de professors que hi ha en aquest departament. El resultat només ha d'incloure els departaments que tenen professors associats i haurà d'estar ordenat de major a menor pel nombre de professors.
SELECT departamento.nombre AS 'departamento', COUNT(id_profesor) AS 'num. profesores' FROM departamento INNER JOIN profesor ON profesor.id_departamento = departamento.id group by departamento.nombre ORDER BY 2 DESC;

-- 4. Retorna un llistat amb tots els departaments i el nombre de professors que hi ha en cadascun d'ells. Tingui en compte que poden existir departaments que no tenen professors associats. Aquests departaments també han d'aparèixer en el llistat.
SELECT departamento.nombre AS 'departamento', COUNT(id_profesor) AS 'num. profesores' FROM departamento LEFT JOIN profesor ON profesor.id_departamento = departamento.id group by departamento.nombre;

-- 5. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun. Tingui en compte que poden existir graus que no tenen assignatures associades. Aquests graus també han d'aparèixer en el llistat. El resultat haurà d'estar ordenat de major a menor pel nombre d'assignatures.
SELECT grado.nombre AS 'grado', COUNT(asignatura.id) AS 'num. asignaturas' FROM grado LEFT JOIN asignatura ON asignatura.id_grado = grado.id GROUP BY grado.nombre ORDER BY 2 DESC;

-- 6. Retorna un llistat amb el nom de tots els graus existents en la base de dades i el nombre d'assignatures que té cadascun, dels graus que tinguin més de 40 assignatures associades.
SELECT grado.nombre AS 'Grado', COUNT(asignatura.id) AS 'num. asignaturas' FROM grado INNER JOIN asignatura ON grado.id = asignatura.id_grado GROUP BY grado.id HAVING COUNT(asignatura.id) > 40;

-- 7. Retorna un llistat que mostri el nom dels graus i la suma del nombre total de crèdits que hi ha per a cada tipus d'assignatura. El resultat ha de tenir tres columnes: nom del grau, tipus d'assignatura i la suma dels crèdits de totes les assignatures que hi ha d'aquest tipus.
SELECT grado.nombre AS 'grado', asignatura.tipo AS 'asignatura', SUM(asignatura.creditos) AS 'num.créditos' FROM grado INNER JOIN asignatura ON asignatura.id_grado = grado.id GROUP BY grado.nombre, asignatura.tipo;

-- 8. Retorna un llistat que mostri quants alumnes s'han matriculat d'alguna assignatura en cadascun dels cursos escolars. El resultat haurà de mostrar dues columnes, una columna amb l'any d'inici del curs escolar i una altra amb el nombre d'alumnes matriculats.
SELECT curso_escolar.anyo_inicio, COUNT(alumno_se_matricula_asignatura.id_alumno) FROM curso_escolar INNER JOIN alumno_se_matricula_asignatura ON alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id GROUP BY curso_escolar.anyo_inicio;

-- 9. Retorna un llistat amb el nombre d'assignatures que imparteix cada professor. El llistat ha de tenir en compte aquells professors que no imparteixen cap assignatura. El resultat mostrarà cinc columnes: id, nom, primer cognom, segon cognom i nombre d'assignatures. El resultat estarà ordenat de major a menor pel nombre d'assignatures.
SELECT persona.id, apellido1, apellido2, persona.nombre, COUNT(asignatura.id) FROM persona LEFT JOIN profesor ON profesor.id_profesor = persona.id LEFT JOIN asignatura USING(id_profesor) GROUP BY persona.id ORDER BY COUNT(asignatura.id) DESC;

-- 10. Retorna totes les dades de l'alumne més jove.
SELECT * FROM persona WHERE persona.tipo = 'alumno' ORDER BY fecha_nacimiento LIMIT 1;

-- 11. Retorna un llistat amb els professors que tenen un departament associat i que no imparteixen cap assignatura
SELECT persona.id, apellido1, apellido2, persona.nombre FROM persona INNER JOIN profesor ON profesor.id_profesor = persona.id LEFT JOIN asignatura USING(id_profesor) WHERE asignatura.id_profesor IS NULL;

