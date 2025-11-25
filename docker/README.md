# Docker Setup

Docker configuration for local MongoDB development with replica set support.

## Services

### MongoDB
- **Port**: 27017
- **Replica Set**: rs0 (single node)
- **Credentials**: 
  - Username: `admin`
  - Password: `admin`
- **Health Check**: Verifies replica set status

### Mongo Express (UI)
- **Port**: 8081
- **URL**: http://localhost:8081
- **Credentials**:
  - Username: `admin`
  - Password: `admin`

## Usage

### Start services
```bash
docker-compose up -d
```

### Stop services
```bash
docker-compose down
```

### View logs
```bash
docker-compose logs -f mongo
```

### Access Mongo Express
Open http://localhost:8081 in your browser and login with:
- Username: `admin`
- Password: `admin`

## Database Connection String

For Prisma and your applications, use:
```
mongodb://admin:admin@localhost:27017/smart-receipt?replicaSet=rs0&authSource=admin
```

Set this in your `.env` file as `DATABASE_URL`.

## Replica Set

The MongoDB instance is configured with a replica set (`rs0`) which is required for:
- Change streams
- Transactions
- Some MongoDB features that Prisma may use

The replica set is automatically initialized when the container starts.

