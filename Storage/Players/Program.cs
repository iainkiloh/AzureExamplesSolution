using System;
using System.Threading.Tasks;
using System.Configuration;
using System.Net;
using Microsoft.Azure.Cosmos;
using Players.ContainerModels;

namespace Players
{
    class Program
    {
        private const string Dbname = "Players";
        private const string ContainerName = "Profiles";
        private static readonly string EndpointUri = ConfigurationManager.AppSettings["EndPointUri"];
        private static readonly string PrimaryKey = ConfigurationManager.AppSettings["PrimaryKey"];

        private CosmosClient _cosmosClient;
        private static Database _database;
        private static Container _profilesContainer;

        public static async Task Main(string[] args)
        {
                Program p = new Program();
                await p.InitialiseEnvironment();
                await p.RunDemo();
                Console.WriteLine("End of Players demo, press any key to exit.");
                Console.ReadKey();
        }

        private async Task<bool> InitialiseEnvironment()
        {
            try
            {
                _cosmosClient = new CosmosClient(EndpointUri, PrimaryKey, new CosmosClientOptions { ApplicationName = "Players" });
                _database = await _cosmosClient.CreateDatabaseIfNotExistsAsync(Dbname);
                _profilesContainer = await _database.CreateContainerIfNotExistsAsync(ContainerName, "/gamerId");
            }
            catch
            {
                Console.WriteLine("Err creating environemtn, check you shitty code and try again");
            }

            return true;
        }

        private async Task RunDemo()
        {
            // create profile 1
            var profile1 = new Profile { GamerId = 7777, Team = "red", GamerTag = "Darth Delmar", StatusMessage = "glhf", IsOnline = true };
            await AddProfileToContainerAsync(profile1);

            var profile2 = new Profile { GamerId = 1111, Team = "green", GamerTag = "Darth Doggy", StatusMessage = "glhf", IsOnline = true };
            await AddProfileToContainerAsync(profile2);

            var profile3 = new Profile { GamerId = 1112, Team = "blue", GamerTag = "Darth Jiggy", StatusMessage = "glhf", IsOnline = false };
            await AddProfileToContainerAsync(profile3);

            var profile4 = new Profile { GamerId = 1114, Team = "red", GamerTag = "Darth Fandan", StatusMessage = "glhf", IsOnline = true };
            await AddProfileToContainerAsync(profile4);

            var profile5 = new Profile { GamerId = 1115, Team = "red", GamerTag = "Darth Blah", StatusMessage = "glhf", IsOnline = true };
            await AddProfileToContainerAsync(profile5);

            var profile6 = new Profile { GamerId = 1116, Team = "red", GamerTag = "Darth OneSix", StatusMessage = "glhf", IsOnline = true };
            await AddProfileToContainerAsync(profile6);

            await UpdateTeamToContainerAsync(profile5.Id, profile5.GamerId, "blue");

            await QueryItemsAsync();

            await ChangeContainerThroughput();

            await DeleteItemAsync(profile6);

            //await Cleanup();
        }

        private async Task ChangeContainerThroughput()
        {
            // Read the current throughput
            try
            {
                int? throughput = await _profilesContainer.ReadThroughputAsync();
                if (throughput.HasValue)
                {
                    Console.WriteLine("Current provisioned throughput : {0}\n", throughput.Value);
                    int newThroughput = throughput.Value + 100;
                    // Update throughput
                    await _profilesContainer.ReplaceThroughputAsync(newThroughput);
                    Console.WriteLine("New provisioned throughput : {0}\n", newThroughput);
                }
            }
            catch (CosmosException cosmosException) when (cosmosException.StatusCode == HttpStatusCode.BadRequest)
            {
                Console.WriteLine("Cannot read container throuthput.");
                Console.WriteLine(cosmosException.ResponseBody);
            }
        }

        private async Task AddProfileToContainerAsync(Profile item)
        {
            try
            {
                // Read the item to see if it exists.  
                ItemResponse<Profile> itemResponse = await _profilesContainer.ReadItemAsync<Profile>(item.Id, new PartitionKey(item.GamerId));
                Console.WriteLine("Item in database with id: {0} already exists\n", itemResponse.Resource.GamerId);
            }
            catch (CosmosException ex) when (ex.StatusCode == HttpStatusCode.NotFound)
            {
                // Create an item in the container
                ItemResponse<Profile> itemResponse = await _profilesContainer.CreateItemAsync(item, new PartitionKey(item.GamerId));

                // Note that after creating the item, we can access the body of the item with the Resource property off the ItemResponse. We can also access the RequestCharge property to see the amount of RUs consumed on this request.
                Console.WriteLine("Created item in database with id: {0} Operation consumed {1} RUs.\n", itemResponse.Resource.GamerId, itemResponse.RequestCharge);
            }
        }

        private async Task UpdateTeamToContainerAsync(string itemId, int partitionKey, string newTeam)
        {
            ItemResponse<Profile> response = await _profilesContainer.ReadItemAsync<Profile>(itemId, new PartitionKey(partitionKey));
            var itemBody = response.Resource;

            itemBody.Team = newTeam;

            // replace the item with the updated content
            response = await _profilesContainer.ReplaceItemAsync<Profile>(itemBody, itemBody.Id, new PartitionKey(partitionKey));

            Console.WriteLine("Updated Profile [{0},{1}].\n \tBody is now: {2}\n", itemBody.GamerId, itemBody.GamerTag, response.Resource);
        }

        private async Task QueryItemsAsync()
        {
            Console.WriteLine("\tFetching profiles in red team\n");

            var sqlQueryText = "SELECT * FROM c WHERE c.Team = 'red'";

            Console.WriteLine("Running query: {0}\n", sqlQueryText);

            QueryDefinition queryDefinition = new QueryDefinition(sqlQueryText);
            FeedIterator<Profile> queryResultSetIterator = _profilesContainer.GetItemQueryIterator<Profile>(queryDefinition);

            while (queryResultSetIterator.HasMoreResults)
            {
                FeedResponse<Profile> currentResultSet = await queryResultSetIterator.ReadNextAsync();
                foreach (var profile in currentResultSet)
                {
                    Console.WriteLine("\tRead {0}\n", profile);
                }
            }
        }

        private async Task DeleteItemAsync(Profile itemToDelete)
        {
            // Delete an item. Note we must provide the partition key value and id of the item to delete
            ItemResponse<Profile> response = await _profilesContainer.DeleteItemAsync<Profile>(itemToDelete.Id, new PartitionKey(itemToDelete.GamerId));
            Console.WriteLine("Deleted Profile [{0},{1}]\n", itemToDelete.GamerId, itemToDelete.Id);
        }

        private async Task Cleanup()
        {
            await _profilesContainer.DeleteContainerAsync();
            await _database.DeleteAsync();
            _cosmosClient.Dispose();

        }

    }
}
