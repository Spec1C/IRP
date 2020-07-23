Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	ThisObject.DocumentAmount = ThisObject.ItemList.Total("TotalAmount");
EndProcedure

Procedure Posting(Cancel, PostingMode)
	
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	
EndProcedure

Procedure UndoPosting(Cancel)
	
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "PurchaseOrder" Then
			Filling_BasedOnPurchaseOrder(FillingData);
		EndIf;
		If FillingData.Property("BasedOn") And FillingData.BasedOn = "SalesOrder" Then
			
			Filling_BasedOnPurchaseOrder(FillingData);
			
		EndIf;
	EndIf;
EndProcedure

Procedure Filling_BasedOnPurchaseOrder(FillingData)
	FillPropertyValues(ThisObject, FillingData,
		"Company,Partner,LegalName,Agreement,Currency,PriceIncludeTax");
	
	For Each Row In FillingData.ItemList Do
		NewRow = ThisObject.ItemList.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	For Each Row In FillingData.TaxList Do
		NewRow = ThisObject.TaxList.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
	For Each Row In FillingData.SpecialOffers Do
		NewRow = ThisObject.SpecialOffers.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;
EndProcedure

Procedure OnCopy(CopiedObject)
	
	LinkedTables = New Array();
	LinkedTables.Add(SpecialOffers);
	LinkedTables.Add(TaxList);
	LinkedTables.Add(Currencies);
	DocumentsServer.SetNewTableUUID(ItemList, LinkedTables);
	
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If DocumentsServer.CheckItemListStores(ThisObject) Then
		Cancel = True;	
	EndIf;
EndProcedure