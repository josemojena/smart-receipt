#!/bin/bash
set -e

echo "⏳ Waiting for MongoDB to start..."
for i in {1..30}; do
  if mongosh --host mongo:27017 --eval "db.adminCommand('ping')" > /dev/null 2>&1; then
    echo "✅ MongoDB is ready"
    break
  fi
  echo "Waiting for MongoDB... ($i/30)"
  sleep 2
done

echo "📦 Checking replica set..."
#host: "localhost:27017" do not forget down and up the mongo again
mongosh --host mongo:27017 --quiet <<EOF
try {
  var status = rs.status();
  print("✅ Replica set is already initialized");
} catch (e) {
  print("🔄 Initializing replica set...");
  rs.initiate({
    _id: "rs0",
    members: [{ _id: 0, host: "mongo:27017" }]
  });
  print("✅ Replica set initialized successfully");
}
EOF

