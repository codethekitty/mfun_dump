function sstpy = sst2struct(sst)

sstpy=struct;
sstpy.spikes=sst.Spikes.TS;
sstpy.epocs.values=double(sst.Epocs.Values);
sstpy.epocs.var=sst.Epocs.TSOff.Properties.VarNames;
sstpy.epocs.tson=double(sst.Epocs.TSOn);
sstpy.epocs.tsoff=double(sst.Epocs.TSOff);

end