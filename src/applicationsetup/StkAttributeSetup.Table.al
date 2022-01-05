/// <summary>
/// TablePTEStkAttributeSetup (ID 50100).
/// </summary>
table 50100 PTEStkAttributeSetup
{
    Caption = 'Stocked Attribute Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = CustomerContent;
        }
        field(2; Enabled; Boolean)
        {
            Caption = 'Enabled';
            DataClassification = CustomerContent;
        }
        field(3; EntryPageType; Enum PTEStkAttributeEntryPageType)
        {
            Caption = 'Entry Page Type';
            DataClassification = CustomerContent;
            InitValue = None;

            trigger OnValidate()
            var
                DefaultErr: Label 'Cannot select default for the default';
            begin
                if EntryPageType = EntryPageType::Default then
                    Error(DefaultErr);
            end;
        }
    }
    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

}
