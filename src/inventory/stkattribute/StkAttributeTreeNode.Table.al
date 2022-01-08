/// <summary>
/// TablePTEStkAttributeTreeNode (ID 50101).
/// </summary>
table 50101 PTEStkAttributeTreeNode
{
    Caption = 'Stocked Attribute Tree Node';
    DataClassification = CustomerContent;

    fields
    {
        field(1; ParentAttributeSetID; Integer)
        {
            Caption = 'Attribute Set ID';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; AttributeValueID; Integer)
        {
            Caption = 'Attribute Value ID';
            DataClassification = CustomerContent;
        }
        field(3; StkAttributeSetId; Integer)
        {
            Caption = 'Attribute Set ID';
            AutoIncrement = true;
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(4; InUse; Boolean)
        {
            caption = 'In Use';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; ParentAttributeSetId, AttributeValueId)
        {
            Clustered = true;
        }
    }
}

