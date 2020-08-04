table 50103 StockedAttributeTemplateTree
{
    Caption = 'Stocked Attribute Template';
    DataClassification = SystemMetadata;

    fields
    {
        field(1; "Parent Template Set ID"; Integer)
        {
            Caption = 'Parent Template Set ID';
            NotBlank = true;
            DataClassification = SystemMetadata;
        }
        field(2; "Template Attribute ID"; Integer)
        {
            Caption = 'Template Attribute ID';
            DataClassification = SystemMetadata;
        }
        field(3; "Template Value ID"; Integer)
        {
            Caption = 'Template Value ID';
            DataClassification = SystemMetadata;
        }
        field(4; "Template Set ID"; Integer)
        {
            Caption = 'Template Set ID';
            AutoIncrement = true;
            DataClassification = SystemMetadata;
            Editable = false;
        }
        field(5; "In Use"; Boolean)
        {
            caption = 'In Use';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(PK; "Parent Template Set ID", "Template Attribute ID", "Template Value ID")
        {
            Clustered = true;
        }
    }
}

