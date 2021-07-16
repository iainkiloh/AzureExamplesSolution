using Newtonsoft.Json;
using System;

namespace Players.ContainerModels
{
    public class Profile
    {
        [JsonProperty(PropertyName = "id")]
        public string Id { get; private set; }

        [JsonProperty(PropertyName = "gamerId")]
        public int GamerId { get; set;  }
        public string Team { get; set; }
        public string GamerTag { get; set; }
        public string StatusMessage { get; set; }
        public bool IsOnline { get; set; }

        public Profile()
        {
            Id = Guid.NewGuid().ToString();
        }

        public override string ToString()
        {
            return JsonConvert.SerializeObject(this);
        }
    }
}
