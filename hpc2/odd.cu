#include<stdio.h>
#include<cuda.h>
#include<stdlib.h>
#define DIVIDER	10000
__global__ void even(int *darr,int n)
{
   int k=blockIdx.x*512+threadIdx.x;
    int t;
     k=k*2; //for even positions
      if(k< n-1)
       {
          if(darr[k]>darr[k+1])
            {  //swap the numbers
               t=darr[k];
                darr[k]=darr[k+1];
                darr[k+1] =t;
             }
       }
}

__global__ void odd(int *darr,int n)
{
   int k=blockIdx.x*512+threadIdx.x;
    int t;
     k=k*2 +1; //for odd positions
      if(k< n-1)
       {
          if(darr[k]>darr[k+1])
            {  //swap the numbers
               t=darr[k];
                darr[k]=darr[k+1];
                darr[k+1] =t;
             }
       }
}
int main()
{
 int *arr,*darr;
 int n,i;
 time_t t;
     srand((unsigned)time(&t));
  printf("\n Enter how many numbers :");
  scanf("%d",&n);
  arr=(int *)malloc(n*sizeof(int));  //for dynamic inputs

   for(i=0; i<n; i++)
	{
		arr[i] = (rand() % DIVIDER) + 1;
        }
  //  printf("\n UNSORTED ARRAY  \n");
  //   for(i=0; i<n; i++)
    //    printf("\t%d",arr[i]);

  cudaMalloc(&darr,n*sizeof(int));  //memory allocation in GPU for darr
  cudaMemcpy(darr,arr ,n*sizeof(int) ,cudaMemcpyHostToDevice); // data transfer from host to GPU

  for(i=0;i<=n/2;i++)
   {
       even<<<n/1024+1,512>>>(darr,n);
       odd<<<n/1024+1,512>>>(darr,n);
   }
cudaMemcpy(arr,darr,n*sizeof(int),cudaMemcpyDeviceToHost);

printf("\n SORTED ARRAY  \n");
     for(i=0; i<n; i++)
      printf("\t%d",arr[i]);

}



Enter how many numbers :1050

SORTED ARRAY
	6	8	12	60	60	61	63	93	93	118	126	128	177	181	209	214	216	218	231	232
	242	245	264	294	297	298	298	322	333	336	364	389	406	417	425	431	433	443	469	476
	481	486	500	505	517	525	533	543	547	557	564	583	587	593	598	606	616	623	626	632
	633	644	655	656	663	673	675	705	708	709	720	723	743	751	757	805	806	806	810	827
	837	840	846	846	847	853	858	860	862	875	887	888	898	898	937	938	954	977	988	995
	1007	1007	1019	1019	1022	1023	1025	1033	1036	1051
	1054	1057	1064	1067	1075	1076	1100	1105	1108	1112
	1118	1122	1144	1171	1173	1181	1196	1196	1198	1205
	1240	1242	1243	1261	1270	1280	1280	1280	1283	1295
	1304	1337	1338	1339	1344	1363	1372	1380	1383	1385
	1395	1398	1402	1432	1439	1441	1449	1455	1466	1475
	1491	1497	1504	1512	1531	1534	1553	1555	1559	1570
	1573	1576	1582	1584	1584	1605	1607	1609	1622	1625
	1628	1646	1653	1667	1677	1683	1687	1692	1699	1715
	1735	1739	1759	1771	1782	1789	1789	1791	1824	1842
	1856	1883	1886	1889	1897	1909	1913	1931	1932	1932
	1933	1952	1960	1962	1965	1970	1980	1981	1997	2010
	2036	2037	2042	2049	2066	2073	2073	2087	2096	2099
	2117	2119	2123	2133	2153	2156	2168	2173	2180	2187
	2200	2223	2235	2240	2246	2256	2276	2301	2311	2314
	2319	2346	2351	2352	2378	2386	2391	2399	2404	2408
	2426	2463	2476	2481	2482	2485	2495	2496	2496	2498
	2503	2510	2520	2520	2532	2535	2544	2545	2555	2564
	2566	2578	2580	2597	2603	2604	2626	2651	2657	2658
	2667	2670	2675	2683	2685	2689	2693	2700	2712	2715
	2721	2724	2726	2734	2744	2745	2782	2789	2803	2804
	2823	2824	2841	2855	2856	2871	2874	2878	2906	2929
	2932	2935	2947	2949	2958	2967	2981	2989	2997	3006
	3010	3016	3020	3038	3040	3043	3052	3056	3067	3068
	3069	3075	3092	3094	3094	3104	3110	3117	3122	3137
	3137	3146	3147	3187	3201	3203	3225	3229	3244	3292
	3320	3323	3325	3350	3355	3361	3390	3407	3417	3432
	3436	3438	3440	3459	3461	3462	3471	3481	3482	3488
	3498	3509	3529	3531	3538	3545	3550	3552	3565	3565
	3571	3573	3580	3607	3609	3621	3625	3635	3641	3657
	3661	3662	3662	3674	3682	3699	3707	3751	3762	3762
	3768	3771	3814	3822	3837	3842	3848	3857	3880	3888
	3901	3911	3934	3939	3943	3954	3958	3961	3971	3976
	3983	3998	3998	4020	4021	4038	4039	4046	4048	4056
	4064	4069	4071	4076	4090	4093	4118	4125	4139	4141
	4159	4170	4170	4172	4180	4188	4195	4203	4207	4218
	4226	4230	4231	4243	4252	4254	4267	4276	4279	4287
	4291	4293	4303	4316	4333	4334	4335	4337	4349	4352
	4361	4363	4369	4383	4393	4405	4408	4412	4422	4425
	4435	4438	4443	4445	4447	4455	4460	4462	4462	4464
	4467	4468	4473	4476	4478	4484	4489	4489	4499	4522
	4523	4534	4540	4541	4577	4589	4591	4607	4607	4614
	4630	4642	4643	4646	4658	4658	4662	4683	4689	4690
	4699	4718	4719	4740	4761	4775	4779	4782	4789	4825
	4831	4836	4842	4844	4861	4868	4877	4889	4892	4895
	4901	4926	4939	4950	4958	4965	4967	4968	4971	4981
	4984	4985	4991	4998	5010	5012	5013	5016	5023	5052
	5080	5088	5089	5146	5155	5168	5173	5177	5187	5192
	5201	5201	5218	5227	5249	5267	5267	5275	5277	5282
	5284	5290	5291	5294	5303	5306	5310	5311	5314	5318
	5326	5344	5344	5344	5346	5366	5374	5378	5381	5384
	5399	5408	5416	5417	5436	5461	5461	5463	5464	5472
	5486	5494	5494	5516	5519	5524	5527	5535	5542	5544
	5558	5568	5573	5594	5610	5610	5648	5658	5668	5682
	5685	5692	5705	5707	5707	5718	5724	5729	5733	5741
	5753	5762	5765	5765	5768	5779	5785	5814	5817	5838
	5841	5846	5859	5867	5894	5898	5906	5911	5915	5921
	5922	5930	5940	5942	5943	5944	5969	5979	5999	6010
	6013	6022	6038	6068	6093	6095	6119	6132	6147	6158
	6163	6167	6169	6194	6195	6211	6251	6254	6254	6271
	6274	6281	6298	6331	6337	6342	6346	6365	6365	6374
	6394	6397	6402	6410	6417	6422	6423	6432	6434	6435
	6442	6452	6452	6466	6474	6486	6500	6503	6528	6535
	6538	6586	6590	6610	6615	6640	6688	6688	6689	6694
	6694	6732	6739	6752	6753	6756	6757	6768	6772	6773
	6797	6801	6803	6813	6828	6840	6842	6843	6866	6869
	6873	6892	6898	6910	6928	6939	6942	6947	6949	6973
	6984	7012	7040	7046	7053	7070	7079	7084	7107	7129
	7131	7136	7137	7143	7154	7167	7176	7181	7195	7197
	7202	7213	7213	7222	7226	7226	7286	7307	7309	7309
	7315	7328	7347	7356	7371	7388	7389	7392	7400	7404
	7405	7412	7414	7425	7446	7450	7452	7459	7462	7467
	7471	7483	7483	7487	7488	7488	7489	7492	7511	7511
	7523	7525	7527	7531	7552	7560	7576	7580	7582	7627
	7628	7667	7673	7701	7708	7738	7756	7756	7759	7772
	7785	7786	7795	7808	7808	7812	7842	7846	7859	7895
	7900	7923	7928	7928	7929	7931	7943	7944	7951	7963
	7968	7969	7971	7975	7993	8013	8020	8035	8050	8061
	8062	8077	8091	8095	8103	8105	8107	8138	8145	8193
	8215	8233	8254	8264	8268	8298	8301	8303	8304	8311
	8318	8337	8337	8341	8350	8382	8388	8391	8398	8398
	8402	8407	8411	8432	8439	8448	8455	8476	8491	8514
	8515	8539	8540	8555	8557	8578	8590	8601	8602	8617
	8625	8651	8665	8665	8705	8714	8718	8731	8737	8753
	8753	8754	8757	8758	8765	8765	8789	8798	8818	8824
	8828	8840	8842	8843	8845	8847	8849	8872	8882	8886
	8892	8915	8933	8937	8941	8942	8942	8944	8945	8965
	8967	8972	8981	8984	8995	8996	8998	9019	9027	9050
	9075	9103	9103	9105	9118	9119	9127	9132	9134	9175
	9178	9202	9209	9219	9222	9242	9246	9251	9254	9279
	9341	9371	9413	9436	9437	9445	9446	9453	9512	9532
	9539	9543	9553	9564	9569	9578	9580	9600	9612	9632
	9642	9652	9662	9671	9684	9688	9697	9712	9717	9720
	9723	9726	9733	9750	9770	9774	9783	9797	9831	9883
	9901	9907	9916	9939	9957	9960	9962	9964	9988	9998