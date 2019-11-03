#include<stdio.h>
const int threshold=10;
const int m=1024;
__global__ void selection_sort(int *data, int left, int right)
{
	int temp,i,j;
	//printf("in selection sort\n");
    for(i=left;i<right; i++)
    	 for(j=i+1;j<=right;j++)
    		if(data[i] > data[j])
    		{
    			temp=data[i];
    			data[i]=data[j];
    			data[j]=temp;
    		}
}

__global__ void partition(int *a,int left,int right,int pivot,int *al,int *ah)
{


	int l,h,i;
	int diff=(right-left+1)/m;
	int k1=threadIdx.x*diff+left;
	int k2=k1+diff-1;
	if(threadIdx.x==m-1)
		k2=right;
//	printf("in partition %d %d and k1= %d  k2= %d \n",left,right,k1,k2);
	l=h=k1;
	for(i=k1;i<=k2;i++)
		{
			al[i]=ah[i]=-999;
		}
	for(i=k1;i<=k2;i++)
	{
		if(a[i] < pivot)
		{
			al[l++]=a[i];
		}
		else
		{
			if(a[i] > pivot)
			{
				ah[h++]=a[i];
			}
		}
	}


}
//__global__
void quicksort(int *a, const int left, const int right)
{
	//printf("in quick sort %d %d \n",left,right);
    if (right-left <= threshold)
    {
    	int *ad;
    	cudaMalloc((void **)&ad,(right-left+1)*sizeof(int));
    	cudaMemcpy(ad,a,(right-left+1)*sizeof(int),cudaMemcpyHostToDevice);
        selection_sort<<<1,1>>>(ad, left, right);
        cudaMemcpy(a,ad,(right-left+1)*sizeof(int),cudaMemcpyDeviceToHost);
        return;
    }
    int pivot=a[left];
    int *al,*ah;
    int *ad;
    cudaMalloc((void **)&ad,(right-left+1)*sizeof(int));
    cudaMalloc((void **)&al,(right-left+1)*sizeof(int));
    cudaMalloc((void **)&ah,(right-left+1)*sizeof(int));

    cudaMemcpy(ad,a,(right-left+1)*sizeof(int),cudaMemcpyHostToDevice);

    partition<<<1,m>>>(ad,left,right,pivot,al,ah);

    int al_h[right-left+1],ah_h[right-left+1];

        cudaMemcpy(al_h,al,(right-left+1)*sizeof(int),cudaMemcpyDeviceToHost);

        cudaMemcpy(ah_h,ah,(right-left+1)*sizeof(int),cudaMemcpyDeviceToHost);

    int i=0,k=0;

    while(i < right-left+1)
    {
    	while(al_h[i]==-999 && i < right-left+1)
    			i++;
    	while(al_h[i]!=-999 && i < right-left+1)
    	{
    		al_h[k++]=al_h[i++];
    	}
    }


    //quicksort<<<1,1>>>(al,0,k-1);
    quicksort(al_h,0,k-1);
    int p=left;
    int x=0;
   // printf("array al");
        while(x < k)
        {
        	a[p++]=al_h[x++];
        	//printf("%d  ",a[p]);

        }
        a[p]=pivot;
    i=0;
    k=0;
    while(i < right-left+1)
    {
      	while(ah_h[i]==-999 && i < right-left+1)
    		i++;
       	while(ah_h[i]!=-999 && i < right-left+1)
       	{
       		ah_h[k++]=ah_h[i++];
       	}
    }
    //quicksort<<<1,1>>>(ah,0,k-1);
    quicksort(ah_h,0,k-1);
    i=0;
    p++;
        while(i < k)
        {
        	a[p++]=ah_h[i++];

        }

}


int main()
{
	int n ;
	printf("\n Enter number of elements :");   //you can give any large number
	scanf("%d",&n);
	int a[n];
	time_t t;
    srand((unsigned)time(&t));

    for (unsigned i = 0 ; i < n ; i++)
    {
    	    	    		a[i]=rand()%n;
    }
    printf("\n\n original array\n");
    for(int i=0; i < n;i++)
    	printf("%d\t ",a[i]);
    quicksort(a,0,n-1);
    printf("\n\n after sorting\n");
    for(int i=0; i < n;i++)
        	printf("%d\t ",a[i]);


}/*
**************************************output**********************************************************
Enter number of elements :1001


original array
372	 714	 453	 297	 548	 632	 339	 131	 544	 573	 559	 322	 300	 274
5	 358	 276	 593	 572	 362	 360	 950	 637	 955	 823	 472	 605	 975
366	 695	 247	 738	 408	 700	 725	 956	 22	 64	 778	 566	 327	 336	 889
627	 300	 584	 675	 577	 177	 247	 629	 227	 887	 265	 872	 709	 427
476	 374	 793	 171	 621	 531	 269	 10	 946	 916	 32	 9	 693	 599	 336	 719
177	 654	 19	 761	 328	 286	 628	 265	 915	 855	 842	 870	 417	 241	 987
893	 615	 780	 754	 926	 0	 23	 936	 946	 939	 659	 956	 321	 257	 982
730	 434	 635	 439	 885	 654	 415	 513	 609	 19	 57	 451	 579	 474	 692
566	 57	 997	 345	 811	 922	 35	 834	 547	 981	 462	 205	 626	 473	 462
608	 894	 586	 933	 332	 471	 586	 748	 674	 886	 457	 421	 336	 36	 586
718	 602	 643	 714	 637	 453	 325	 672	 978	 872	 342	 129	 768	 969
603	 920	 576	 186	 506	 508	 518	 667	 785	 956	 30	 670	 103	 451	 696
139	 36	 413	 431	 369	 817	 758	 823	 141	 119	 490	 703	 461	 619	 470
429	 912	 390	 695	 97	 586	 894	 306	 943	 678	 952	 663	 37	 54	 113	 423
193	 841	 836	 314	 900	 652	 71	 722	 483	 190	 211	 185	 342	 521	 656
771	 432	 736	 466	 220	 321	 49	 526	 954	 417	 477	 616	 454	 532	 419
877	 415	 950	 402	 730	 850	 53	 491	 261	 536	 372	 473	 411	 714	 684
66	 174	 806	 802	 330	 25	 813	 379	 241	 456	 796	 409	 71	 940	 941
491	 816	 45	 130	 217	 465	 980	 961	 647	 241	 186	 18	 404	 598	 422
87	 354	 286	 893	 847	 617	 609	 349	 996	 850	 806	 482	 949	 877
421	 579	 57	 237	 625	 188	 144	 780	 858	 796	 426	 98	 672	 134	 502
960	 246	 279	 4	 533	 863	 851	 149	 161	 199	 835	 701	 695	 316	 650
262	 738	 228	 9	 665	 853	 888	 499	 323	 746	 294	 749	 534	 657	 574
727	 306	 820	 5	 310	 352	 558	 160	 191	 719	 50	 26	 110	 435	 342	 760
697	 770	 988	 707	 434	 531	 594	 624	 854	 29	 608	 292	 564	 264	 866
290	 571	 686	 986	 881	 728	 234	 732	 920	 643	 472	 636	 753	 907
978	 512	 294	 438	 190	 0	 562	 411	 284	 185	 955	 4	 794	 937	 568
748	 803	 548	 8	 178	 223	 580	 596	 457	 311	 515	 100	 473	 150	 853
69	 819	 55	 363	 947	 936	 53	 508	 36	 338	 384	 991	 342	 868	 927	 600
615	 419	 147	 314	 287	 60	 894	 884	 518	 895	 88	 308	 367	 930	 851
126	 748	 596	 490	 384	 531	 543	 582	 567	 571	 966	 247	 913	 523
174	 202	 829	 283	 39	 142	 571	 100	 35	 144	 308	 930	 232	 616	 987
161	 156	 803	 599	 753	 292	 983	 974	 836	 565	 231	 406	 220	 478
9	 744	 342	 211	 572	 626	 942	 714	 887	 41	 439	 30	 349	 58	 262	 655
735	 114	 811	 537	 713	 253	 830	 386	 227	 355	 951	 458	 451	 861
626	 460	 604	 969	 362	 866	 284	 303	 269	 861	 34	 708	 891	 383	 766
843	 728	 500	 957	 228	 37	 360	 482	 557	 746	 399	 912	 386	 547	 52
246	 863	 513	 541	 521	 565	 406	 805	 558	 676	 665	 592	 73	 245	 665
530	 88	 82	 29	 735	 310	 757	 94	 482	 3	 840	 571	 605	 225	 117	 658	 162
981	 861	 703	 191	 425	 799	 997	 673	 164	 351	 264	 238	 597	 619
768	 685	 701	 487	 419	 10	 935	 204	 183	 938	 43	 754	 543	 960	 872
200	 121	 542	 60	 824	 733	 175	 312	 419	 848	 477	 771	 802	 405	 57
420	 172	 432	 811	 349	 541	 821	 283	 745	 3	 912	 789	 758	 454	 438
319	 344	 559	 551	 94	 72	 974	 960	 384	 83	 497	 861	 544	 298	 265	 601
408	 127	 723	 218	 167	 263	 729	 140	 8	 423	 51	 487	 871	 195	 925
880	 229	 173	 430	 323	 245	 93	 973	 629	 176	 469	 490	 410	 457	 445
10	 555	 263	 733	 463	 430	 687	 192	 260	 385	 305	 312	 872	 175
507	 486	 54	 427	 659	 174	 440	 904	 958	 413	 222	 825	 572	 402	 234
720	 538	 936	 965	 801	 358	 428	 921	 44	 310	 180	 429	 615	 182	 991
480	 380	 166	 534	 807	 515	 708	 246	 108	 355	 659	 331	 179	 922
733	 414	 641	 270	 349	 605	 761	 707	 723	 371	 442	 32	 242	 871	 337
424	 552	 817	 804	 718	 350	 610	 233	 748	 857	 341	 103	 205	 362
973	 817	 95	 386	 457	 55	 425	 753	 817	 132	 475	 878	 574	 198	 119
134	 535	 544	 686	 352	 347	 94	 392	 648	 327	 831	 194	 358	 624	 89
721	 596	 907	 506	 983	 53	 561	 407	 806	 67	 229	 972	 946	 493	 169
64	 318	 394	 298	 694	 436	 336	 788	 829	 674	 805	 349	 868	 163	 973
647	 574	 258	 553	 79	 931	 607	 330	 338	 102	 88	 257	 764	 724	 441	 933
788	 759	 17	 777	 142	 453	 112	 931	 972	 786	 735	 320	 343	 588	 983	 990
852	 241	 233	 621	 171	 840	 642	 199	 632	 730	 147	 396	 453	 588	 18	 931
36	 35	 397	 178	 179	 509	 108	 150	 985	 534	 161	 327	 812	 834	 7	 354
765	 240	 665	 937	 770	 306	 826	 401	 726	 663	 487	 178	 250	 506	 800
977	 231	 196	 155	 100	 396	 954	 942	 380	 177	 102	 398	 680	 626	 405
33	 391	 335	 388	 17	 104	 695	 533	 195	 420	 196	 683	 289	 446	 879	 779
423	 800	 975	 268	 901	 60	 221	 842	 441	 89	 634	 529	 769	 259	 624	 492
650	 959	 880	 357	 62	 574	 891	 948	 685	 86	 630	 664	 222	 508	 442	 335
308	 416	 603	 899	 477	 515	 740	 608	 604	 63	 827	 372	 322	 450	 554	 663
408	 433	 19	 160	 698	 910	 107	 72

after sorting
0	 0	 3	 3	 4	 4	 5	 7	 8	 8	 9	 9	 9	 10	 17	 17	 18	 18	 19	 19	 19	 17	 19	 22	 23	 25	 26	 29	 29
30	 30	 32	 33	 34	 35	 36	 37	 39	 41	 43	 44	 45	 49	 50	 51	 52	 53	 53	 53	 54	 55	 55	 53	 53	 55	 53	 36	 35
33	 57	 58	 60	 60	 60	 62	 63	 60	 62	 63	 63	 64	 66	 67	 69	 71	 72	 72	 73	 79	 82	 83	 86	 87	 88	 88	 88	 89
89	 93	 94	 94	 94	 95	 72	 97	 98	 100	 100	 100	 102	 102	 103	 104	 107	 108	 108
110	 112	 113	 114	 117	 119	 121	 126	 127	 107	 72	 129	 130	 72	 72	 131	 132
134	 134	 139	 140	 141	 142	 142	 144	 147	 147	 149	 150	 150	 155	 156
160	 160	 161	 162	 163	 164	 166	 167	 169	 155	 160	 160	 171	 172	 173
174	 174	 174	 175	 175	 176	 160	 177	 178	 178	 178	 179	 179	 180	 182
183	 185	 185	 186	 188	 190	 190	 191	 191	 192	 193	 194	 195	 195	 196
196	 198	 199	 199	 200	 202	 204	 196	 205	 211	 211	 217	 218	 220	 220
221	 222	 222	 223	 225	 222	 227	 228	 228	 229	 229	 231	 231	 232	 233
233	 234	 234	 237	 238	 240	 241	 242	 245	 245	 246	 246	 246	 233	 240
231	 222	 222	 160	 247	 250	 253	 257	 258	 259	 260	 261	 262	 262	 263
263	 264	 264	 259	 265	 268	 269	 269	 270	 268	 259	 222	 160	 274	 276
279	 283	 283	 284	 284	 286	 287	 289	 290	 292	 292	 294	 294	 289	 297
298	 298	 300	 303	 305	 306	 308	 308	 308	 310	 310	 310	 311	 312	 312
314	 316	 318	 319	 320	 308	 306	 308	 321	 308	 308	 322	 323	 323	 325
327	 328	 330	 330	 331	 332	 335	 335	 336	 337	 338	 338	 338	 335	 335
335	 335	 322	 339	 341	 342	 342	 342	 342	 342	 343	 344	 345	 347	 349
349	 349	 349	 349	 350	 351	 352	 352	 354	 355	 355	 357	 357	 358	 360
360	 362	 362	 362	 363	 366	 367	 369	 371	 354	 357	 372	 374	 379	 380
380	 383	 384	 384	 384	 385	 386	 386	 386	 388	 390	 391	 392	 394	 396
396	 397	 398	 399	 401	 402	 404	 405	 405	 406	 406	 407	 391	 408	 409
410	 411	 411	 413	 413	 414	 415	 415	 416	 417	 419	 419	 419	 419	 420
420	 421	 422	 423	 423	 423	 424	 425	 425	 426	 423	 416	 427	 428	 429
429	 430	 430	 431	 432	 432	 433	 434	 435	 436	 438	 438	 439	 440	 441
441	 442	 442	 445	 446	 450	 451	 451	 451	 450	 433	 433	 408	 433	 453
454	 454	 456	 457	 457	 457	 457	 458	 460	 461	 462	 463	 465	 466	 469
470	 471	 457	 472	 473	 473	 473	 474	 475	 476	 477	 477	 477	 478	 480
482	 482	 482	 483	 486	 487	 487	 487	 490	 491	 491	 492	 493	 497	 499
500	 502	 492	 477	 506	 507	 508	 508	 508	 509	 512	 508	 477	 513	 515
515	 515	 518	 518	 521	 521	 523	 526	 529	 530	 515	 531	 532	 533	 533
534	 534	 534	 535	 536	 537	 538	 541	 541	 542	 543	 543	 477	 515	 515
544	 547	 547	 477	 515	 548	 551	 552	 553	 554	 555	 557	 558	 558	 559
561	 562	 564	 565	 565	 566	 567	 568	 571	 571	 571	 571	 561	 572	 572
561	 554	 573	 574	 574	 574	 574	 576	 577	 579	 579	 580	 582	 584	 586
586	 586	 586	 588	 588	 592	 593	 594	 596	 596	 596	 597	 598	 599	 600
601	 602	 603	 603	 604	 604	 604	 605	 607	 608	 608	 608	 609	 609	 610
615	 616	 616	 617	 619	 619	 607	 608	 621	 624	 624	 624	 625	 626	 626
626	 626	 608	 627	 628	 629	 629	 630	 608	 604	 632	 634	 635	 636	 637
641	 642	 643	 643	 647	 647	 648	 650	 650	 652	 654	 655	 656	 657	 658
659	 663	 663	 663	 664	 665	 665	 665	 665	 667	 670	 672	 673	 663	 674
663	 664	 663	 663	 675	 676	 678	 680	 683	 684	 685	 685	 686	 686	 687
692	 693	 694	 695	 696	 697	 698	 700	 701	 701	 703	 703	 707	 707	 708
708	 709	 713	 664	 663	 698	 698	 698	 698	 408	 433	 698	 714	 718	 718
719	 719	 720	 721	 722	 723	 723	 724	 725	 726	 727	 728	 728	 729	 730
732	 733	 733	 733	 735	 735	 735	 736	 730	 726	 738	 740	 744	 745	 746
746	 748	 749	 753	 753	 753	 748	 753	 740	 754	 757	 758	 758	 759	 760
740	 761	 764	 765	 766	 768	 768	 769	 770	 770	 771	 771	 777	 740	 778
779	 780	 780	 785	 786	 788	 788	 789	 793	 794	 796	 796	 799	 800	 800
801	 802	 803	 803	 804	 805	 805	 800	 806	 807	 800	 800	 811	 812	 813
816	 817	 817	 817	 817	 819	 820	 821	 800	 800	 740	 823	 824	 825	 826
827	 829	 829	 830	 831	 834	 835	 836	 836	 840	 840	 841	 827	 842	 843
847	 848	 850	 850	 851	 851	 852	 853	 853	 854	 827	 855	 857	 858	 861
861	 861	 861	 863	 863	 866	 866	 868	 868	 870	 871	 871	 872	 877	 877
878	 879	 880	 880	 881	 884	 885	 886	 842	 880	 827	 887	 888	 827	 889
891	 891	 893	 894	 895	 899	 900	 901	 904	 907	 907	 910	 912	 913	 899
910	 899	 910	 910	 915	 916	 920	 920	 921	 922	 922	 925	 926	 927	 930
930	 931	 931	 931	 933	 933	 935	 936	 937	 937	 938	 939	 940	 941	 942
942	 943	 937	 942	 946	 947	 948	 949	 899	 910	 910	 950	 951	 952	 954
954	 955	 956	 957	 958	 959	 960	 960	 960	 961	 965	 966	 969	 972	 972
973	 973	 973	 974	 974	 959	 972	 959	 975	 977	 978	 978	 980	 981	 981
982	 983	 983	 983	 985	 986	 987	 988	 990	 991	 991	 996	 997	 997	 977
959	 959	 910	 433	 698	 910	 107	 72	 */