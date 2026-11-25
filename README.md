# GalenoSV · PPI115 2026 (GT02) · Backend

API REST y páginas JSF de GalenoSV, sobre **Jakarta EE 11** y **Open Liberty**.
La PWA que consume esta API está en el repositorio
[GalenoSV-frontend](https://github.com/aa24010-ppi115-cicloII-2026/GalenoSV-frontend).

---

## 1. Estructura del proyecto

```
src/main/java/sv/edu/ues/occ/ingenieria/ppi115_2026/salud/galenosv/
├── entity/            entidades JPA
├── control/           DAOs @Stateless (DefaultDAO) y TicketService
└── boundary/
    ├── rest/          API /api: un Resource y un DTO por tabla (DefaultResource)
    └── jsf/           modelos de las páginas JSF (src/main/webapp/paginas)
src/test/java/...      pruebas JUnit 5 + Mockito, en el mismo paquete que la clase probada
```

## 2. Requisitos

- Java 21
- Maven
- Open Liberty
- Docker con PostgreSQL 17 para la base de datos

## 3. Levantar el proyecto

### 3.1 Base de datos

```bash
docker run --name db17 -e POSTGRES_USER=admin -e POSTGRES_PASSWORD=admin \
  -e POSTGRES_DB=GalenoSV -p 5432:5432 -d postgres:17.5-alpine
```

La base de datos es la del proyecto original y **no se modifica**: no se crean tablas ni columnas.

### 3.2 Backend (API REST)

```bash
mvn clean package
mvn liberty:dev            # en esta máquina: -DinstallDirectory=/home/duran/wlp
                           # o bien: <LIBERTY>/bin/server start miServidor
```

El default de `installDirectory` del `pom.xml` se conserva para el equipo de presentación; se sobrescribe solo con `-D`. La API queda disponible en `http://localhost:9080/GalenoSV-1.0-SNAPSHOT/api`.

## 4. Pruebas

```bash
mvn -o test                          # todas
mvn -o test -Dtest=InicioBeanTest    # una clase
```

Patrón de las pruebas de unidad: JUnit 5 con Mockito. Hay una clase de prueba por clase, en el
mismo paquete que la clase que prueba (`control` para los DAO, `boundary` y `boundary/jsf` para
los beans y modelos, `boundary/rest` para los recursos). Las dependencias se reemplazan con
mocks (`EntityManager` y `TypedQuery` en los DAO, los DAO y `FacesContext` en los modelos), y cada
prueba sigue tres pasos: preparar lo que devuelven los mocks, ejecutar el método y comprobar el
resultado o la interacción con `verify`.

## 5. API REST

20 recursos CRUD con paginación `first/max`. El total de registros llega en la cabecera
`X-Total-Count` y, en los errores, el parámetro que falló en `X-Parametro-Error`.

Endpoint adicional que usa el frontend:

| Método | Ruta | Descripción |
| ------ | ---- | ----------- |
| GET | `/tickets/consultas/{id}` | Comprobante de la cita en PDF generado con OpenPDF |

## 6. Datos de demostración

El repositorio no trae datos. Datos de ejemplo usados en la demostración:

| Documento    | Persona        | Rol           |
| ------------ | -------------- | ------------- |
| `01234567-8` | José Torres    | Odontólogo    |
| `02345678-9` | María López    | Paciente      |
| `03456789-0` | Ana Ramírez    | Recepcionista |
