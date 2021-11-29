const { MongoClient } = require('mongodb');

const uri = 'mongodb://test:secure@localhost:27017/admin?replicaSet=replica1';

async function main() {
  const client = new MongoClient(uri);

  try {
    await client.connect();

    const testCollection = client.db("test").collection("test_coll");
    const changeStream = testCollection.watch();

    changeStream.on('change', (next) => {
      console.log("event received!")
      console.log(next);
    })
    console.log("listening on changestream!");
    await closeChangeStream(600000, changeStream);
  } finally {
    // Close the connection to the MongoDB cluster
    await client.close();
  }
}


function closeChangeStream(timeInMs = 60000, changeStream) {

  return new Promise((resolve) => {

      setTimeout(() => {

          console.log("Closing the change stream");

          changeStream.close();

          resolve();

      }, timeInMs)

  })

};

main().catch(console.error);
