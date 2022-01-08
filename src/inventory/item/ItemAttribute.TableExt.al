/// <summary>
/// TableExtension PTEItemAttribute (ID 50102) extends Record Item Attribute.
/// </summary>
tableextension 50102 PTEItemAttribute extends "Item Attribute"
{
    fields
    {
        field(50100; PTEStkAttribute; Boolean)
        {
            Caption = 'Stocked Attribute';
            DataClassification = CustomerContent;
        }
    }
}