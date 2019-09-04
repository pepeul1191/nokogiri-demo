# Formatos

## JSON

profes.json

```
[
  {
    "_id": "zoxxdhjageltphmeajbfklan",
    "img": "http://oliva.ulima.edu.pe/imagenes/fotos/162505.jpg",
    "name": "ACUÑA SILLO, ELBA LOURDES",
    "carrers": [
      {
        "_id": "dykjfojfaeosuyumtnzsvcqn",
        "name": "Administración"
      },
      {
        "_id": "sqoqmxsalflwceyxeqxkdwfl",
        "name": "Marketing"
      },
      {
        "_id": "phylcianwhbetupdkotovobh",
        "name": "Negocios Internacionales"
      }
    ]
  },
```

## SQLite3

SQL de la base de datos


```
CREATE TABLE `carrers` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`name`	TEXT NOT NULL
);

CREATE TABLE `teachers` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`names`	TEXT NOT NULL,
	`last_names`	INTEGER NOT NULL,
	`img`	TEXT NOT NULL
);

CREATE TABLE `teachers_carrers` (
	`id`	INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
	`teacher_id`	INTEGER NOT NULL,
	`carrer_id`	INTEGER NOT NULL
);

```

JOIN teachers_carrers

```
SELECT T.id AS teacher_id, T.names, T.last_names, T.img, C.id AS carrer_id,  C.name AS carrer_name
FROM teachers T
INNER JOIN teachers_carrers TC ON TC.teacher_id = T.id
INNER JOIN carrers C ON TC.carrer_id = C.id ;
```

## MongoDB

Comandos backup de MongoDB

    $ mongodump --db profes --host localhost --port 27017 --out ../db

Comandos restore de MongoDB

    $ mongorestore --db profes --host localhost --port 27017 ../db/profes

JOIN teachers_carrers

```
db.teachers.aggregate([
  {
    $unwind: "$carrers"
  },
  {
    $lookup: {
      from: "carrers",
      localField: "carrers",
      foreignField: "_id",
      as: "carrer"
    },
  },
  {
    $unwind: "$carrer"
  },
  {
    $group: {
        "_id": "$_id",
        "names": {
          $push: "$names"
        },
        "last_names": {
          $push: "$last_names"
        },
        "img": {
          $push: "$img"
        },
        "carrers": {
          $push: "$carrer"
        }
    }
  },
  {
    $project: {
      "_id": "$_id",
      "names": { $arrayElemAt: [ "$names", 0 ] },
      "last_names": { $arrayElemAt: [ "$last_names", 0 ] },
      "img": { $arrayElemAt: [ "$img", 0 ] },
      carrers: "$carrers",
    }
  }
])

```

---

Fuentes:

+ https://stackoverflow.com/questions/34967482/lookup-on-objectids-in-an-array
