/// <summary>
/// QueryPTEStkAttributeItemAttributes (ID 50100).
/// </summary>
query 50100 PTEStkAttributeItemAttributes
{
    QueryType = Normal;

    elements
    {
        dataitem(ItemAttribute; "Item Attribute")
        {
            column(ID; ID)
            {
            }
            column(StockedAttribute; PTEStkAttribute)
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
