query 50100 StockedAttributeItemAttributes
{
    QueryType = Normal;

    elements
    {
        dataitem(ItemAttribute; "Item Attribute")
        {
            column(ID; ID)
            {
            }
            column(StockedAttribute; StockedAttribute)
            {
            }
            dataitem(ItemAttributeValue; "Item Attribute Value")
            {

                DataItemLink = "Attribute ID" = ItemAttribute.ID;
                column(ValueID; ID)
                {

                }
            }
        }
    }
}
