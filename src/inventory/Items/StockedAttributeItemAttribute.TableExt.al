/// <summary>
/// TableExtension StockedAttributeItemAttribute (ID 50102) extends Record Item Attribute.
/// </summary>
tableextension 50102 StockedAttributeItemAttribute extends "Item Attribute"
{
    fields
    {
        field(50100; StockedAttribute; Boolean)
        {
            Caption = 'Stocked Attribute';
            DataClassification = CustomerContent;
        }
    }
}