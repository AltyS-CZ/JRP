-- config.lua
Config = {}

Config.item_list = {
    categories = {
        {
            name = "Drinks",
            items = {
                { item = "Water", name = "Water" },
                { item = "Soda", name = "Soda" }
            }
        },
        {
            name = "Food",
            items = {
                { item = "Apple", name = "Apple" },
                { item = "Bread", name = "Bread" }
            }
        },
        {
            name = "Items",
            items = {
                { item = "Bandage", name = "Bandage" },
                { item = "Phone", name = "Phone" },
                { item = "Key", name = "Key" }
            }
        }
    }
}



return Config
