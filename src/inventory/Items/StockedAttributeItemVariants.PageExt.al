pageextension 50103 StockedAttributeItemVariants extends "Item Variants"
{
    layout
    {
        modify(Description)
        {
            Visible = not StockedAttributeVisible;
        }

        addAfter(Code)
        {
            field(StockedAttributeFullDescription; StockedAttributeMgmt.GetVariantFullDescription(Item, "Attribute Set Id"))
            {
                Caption = 'Description';
                ToolTip = 'Full Item Variant description';
                Visible = StockedAttributeVisible;
                Editable = false;
                ApplicationArea = All;

                trigger OnDrillDown()
                begin
                    StockedAttributeMgmt.ShowVariantAttributes("Attribute Set Id");
                end;
            }

            field(Attribute1; AttributeValues[1])
            {
                CaptionClass = '3,' + AttributeCaptions[1];
                Editable = false;
                Visible = AttributeVisible1;
                ApplicationArea = All;
            }
            field(Attribute2; AttributeValues[2])
            {
                CaptionClass = '3,' + AttributeCaptions[2];
                Editable = false;
                Visible = AttributeVisible2;
                ApplicationArea = All;
            }
            field(Attribute3; AttributeValues[3])
            {
                CaptionClass = '3,' + AttributeCaptions[3];
                Editable = false;
                Visible = AttributeVisible3;
                ApplicationArea = All;
            }
            field(Attribute4; AttributeValues[4])
            {
                CaptionClass = '3,' + AttributeCaptions[4];
                Editable = false;
                Visible = AttributeVisible4;
                ApplicationArea = All;
            }
            field(Attribute5; AttributeValues[5])
            {
                CaptionClass = '3,' + AttributeCaptions[5];
                Editable = false;
                Visible = AttributeVisible5;
                ApplicationArea = All;
            }
            field(Attribute6; AttributeValues[6])
            {
                CaptionClass = '3,' + AttributeCaptions[6];
                Editable = false;
                Visible = AttributeVisible6;
                ApplicationArea = All;
            }
            field(Attribute7; AttributeValues[7])
            {
                CaptionClass = '3,' + AttributeCaptions[7];
                Editable = false;
                Visible = AttributeVisible7;
                ApplicationArea = All;
            }
            field(Attribute8; AttributeValues[8])
            {
                CaptionClass = '3,' + AttributeCaptions[8];
                Editable = false;
                Visible = AttributeVisible8;
                ApplicationArea = All;
            }
            field(Attribute9; AttributeValues[9])
            {
                CaptionClass = '3,' + AttributeCaptions[9];
                Editable = false;
                Visible = AttributeVisible9;
                ApplicationArea = All;
            }
            field(Attribute10; AttributeValues[10])
            {
                CaptionClass = '3,' + AttributeCaptions[10];
                Editable = false;
                Visible = AttributeVisible10;
                ApplicationArea = All;
            }
            field(Attribute11; AttributeValues[11])
            {
                CaptionClass = '3,' + AttributeCaptions[11];
                Editable = false;
                Visible = AttributeVisible11;
                ApplicationArea = All;
            }
            field(Attribute12; AttributeValues[12])
            {
                CaptionClass = '3,' + AttributeCaptions[12];
                Editable = false;
                Visible = AttributeVisible12;
                ApplicationArea = All;
            }
            field(Attribute13; AttributeValues[13])
            {
                CaptionClass = '3,' + AttributeCaptions[13];
                Editable = false;
                Visible = AttributeVisible13;
                ApplicationArea = All;
            }
            field(Attribute14; AttributeValues[14])
            {
                CaptionClass = '3,' + AttributeCaptions[14];
                Editable = false;
                Visible = AttributeVisible14;
                ApplicationArea = All;
            }
            field(Attribute15; AttributeValues[15])
            {
                CaptionClass = '3,' + AttributeCaptions[15];
                Editable = false;
                Visible = AttributeVisible15;
                ApplicationArea = All;
            }
            field(Attribute16; AttributeValues[16])
            {
                CaptionClass = '3,' + AttributeCaptions[16];
                Editable = false;
                Visible = AttributeVisible16;
                ApplicationArea = All;
            }
            field(Attribute17; AttributeValues[17])
            {
                CaptionClass = '3,' + AttributeCaptions[17];
                Editable = false;
                Visible = AttributeVisible17;
                ApplicationArea = All;
            }
            field(Attribute18; AttributeValues[18])
            {
                CaptionClass = '3,' + AttributeCaptions[18];
                Editable = false;
                Visible = AttributeVisible18;
                ApplicationArea = All;
            }
            field(Attribute19; AttributeValues[19])
            {
                CaptionClass = '3,' + AttributeCaptions[19];
                Editable = false;
                Visible = AttributeVisible19;
                ApplicationArea = All;
            }
            field(Attribute20; AttributeValues[20])
            {
                CaptionClass = '3,' + AttributeCaptions[20];
                Editable = false;
                Visible = AttributeVisible20;
                ApplicationArea = All;
            }
        }

        addbefore(Control1900383207)
        {
            part(StockedAttributesFactBox; StockedAttributeFactbox)
            {
                ApplicationArea = All;
                Visible = StockedAttributeVisible;
                SubPageLink = AttributeSetID = field("Attribute Set Id");
            }
        }
    }

    actions
    {
        addlast(Processing)
        {
            group(StockedAttributeGrp)
            {
                Visible = StockedAttributeVisible;

                action(CreateAllVariants)
                {
                    Caption = 'Create Variants';
                    ToolTip = 'Create variants, using stocked attribute template';
                    ApplicationArea = All;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    PromotedCategory = Process;
                    Image = Action;

                    trigger OnAction()
                    var
                        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
                    begin
                        StockedAttributeMgmt.CreateAllPossibleVariants("Item No.", false);
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    begin
        StockedAttributeVisible := StockedAttributeMgmt.IsEnabled();
        GetVariantDetail();
        SetAttributeCaptions();
    end;

    trigger OnAfterGetRecord()
    begin
        GetVariantDetail();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        GetVariantDetail();
    end;

    var
        Item: Record Item;
        StockedAttributeMgmt: Codeunit StockedAttributeMgmt;
        StockedAttributeVisible: Boolean;
        AttributeIds: array[20] of iNTEGER;
        AttributeValues: array[20] of Text;
        AttributeCaptions: array[20] of Text;
        AttributeVisible1: Boolean;
        AttributeVisible2: Boolean;
        AttributeVisible3: Boolean;
        AttributeVisible4: Boolean;
        AttributeVisible5: Boolean;
        AttributeVisible6: Boolean;
        AttributeVisible7: Boolean;
        AttributeVisible8: Boolean;
        AttributeVisible9: Boolean;
        AttributeVisible10: Boolean;
        AttributeVisible11: Boolean;
        AttributeVisible12: Boolean;
        AttributeVisible13: Boolean;
        AttributeVisible14: Boolean;
        AttributeVisible15: Boolean;
        AttributeVisible16: Boolean;
        AttributeVisible17: Boolean;
        AttributeVisible18: Boolean;
        AttributeVisible19: Boolean;
        AttributeVisible20: Boolean;
        AttributeCount: Integer;


    local procedure SetAttributeCaptions()
    var
        StockedAttributeTemplate: Record StockedAttributeTemplate;
        TempStockedAttributeTemplateEntry: Record StockedAttributeTemplateEntry temporary;
        PreviousId: Integer;
        x: Integer;
    begin
        if not StockedAttributeVisible then
            exit;

        if not StockedAttributeTemplate.Get(Item.StockedAttributeTemplateCode) then
            exit;

        StockedAttributeMgmt.GetAttributeTemplateSet(TempStockedAttributeTemplateEntry, StockedAttributeTemplate."Template Set ID");
        if not TempStockedAttributeTemplateEntry.FindSet() then
            exit;

        repeat
            if TempStockedAttributeTemplateEntry.AttributeID <> PreviousId then begin
                x += 1;
                TempStockedAttributeTemplateEntry.CalcFields("Attribute Code");
                AttributeIds[x] := TempStockedAttributeTemplateEntry.AttributeID;
                AttributeCaptions[x] := TempStockedAttributeTemplateEntry."Attribute Code";
                SetFieldVisible(x);
            end;
            PreviousId := TempStockedAttributeTemplateEntry.AttributeID;
        until (TempStockedAttributeTemplateEntry.Next() = 0) or (x = ArrayLen(AttributeValues));

        AttributeCount := x;
    end;

    local procedure GetVariantDetail()
    var
        TempStockedAttributeSetEntry: Record StockedAttributeSetEntry temporary;
        x: Integer;
    begin
        if not StockedAttributeVisible then
            exit;

        If Item."No." <> "Item No." then
            if not Item.Get("Item No.") then
                Clear(Item);

        StockedAttributeMgmt.GetAttributeSet(TempStockedAttributeSetEntry, "Attribute Set Id");
        for x := 1 to AttributeCount do begin
            TempStockedAttributeSetEntry.SetRange(AttributeID, AttributeIds[x]);
            if TempStockedAttributeSetEntry.FindFirst() then begin
                TempStockedAttributeSetEntry.CalcFields("Attribute Value");
                AttributeValues[x] := TempStockedAttributeSetEntry."Attribute Value";
            end;
        end;
    end;

    local procedure SetFieldVisible(FieldToSet: Integer)
    begin
        case FieldToSet of
            1:
                AttributeVisible1 := true;
            2:
                AttributeVisible2 := true;
            3:
                AttributeVisible3 := true;
            4:
                AttributeVisible4 := true;
            5:
                AttributeVisible5 := true;
            6:
                AttributeVisible6 := true;
            7:
                AttributeVisible7 := true;
            8:
                AttributeVisible8 := true;
            9:
                AttributeVisible9 := true;
            10:
                AttributeVisible10 := true;
            11:
                AttributeVisible11 := true;
            12:
                AttributeVisible12 := true;
            13:
                AttributeVisible13 := true;
            14:
                AttributeVisible14 := true;
            15:
                AttributeVisible15 := true;
            16:
                AttributeVisible16 := true;
            17:
                AttributeVisible17 := true;
            18:
                AttributeVisible18 := true;
            19:
                AttributeVisible19 := true;
            20:
                AttributeVisible20 := true;
        end;
    end;
}