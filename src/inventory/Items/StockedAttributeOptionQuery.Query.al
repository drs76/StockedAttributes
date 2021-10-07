/// <summary>
/// Query StockedAttributeOptionQry (ID 50101).
/// </summary>
query 50101 StockedAttributeOptionQry
{
    QueryType = Normal;

    elements
    {
        dataitem(ItemAttributeValue; "Item Attribute Value") // options
        {
            // filter only column, not included in results.
            filter(Attribute_Value; Value)
            {
            }

            dataitem(StockedAttributeSetEntry; StockedAttributeSetEntry) //option set entry
            {

                DataItemLink = AttributeValueID = ItemAttributeValue.ID;
                SqlJoinType = InnerJoin;
                column(Attribute_Set_ID; AttributeSetID)
                {
                }

                // this will group the query by Option Set Id and return a count of matched entries in the set (1 entry per word in filter)
                column(AttributeIdCount)
                {
                    Method = Count;
                }
            }
        }
    }
}

