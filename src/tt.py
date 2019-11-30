import torch
import torch.nn as nn

lstm = nn.LSTM(300, 100, 2,bidirectional=True)

x = torch.randn(7, 16, 300)

h0 = torch.randn(4, 16, 100)

c0 = torch.randn(4, 16, 100)

output, (hn, cn)=lstm(x, (h0, c0))

print('output {}'.format(output.size()))
print('hn {}'.format(hn.size()))
print('cn {}'.format(cn.size()))

modellist=nn.ModuleList([nn.Linear(10,10) for i in range(10)])
for i in range(len(modellist)):
    print(modellist[i])
