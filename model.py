
#                         __     __
#    ____ ___  ____  ____/ /__  / /
#   / __ `__ \/ __ \/ __  / _ \/ /
#  / / / / / / /_/ / /_/ /  __/ /
# /_/ /_/ /_/\____/\__,_/\___/_/


from functools import partial

import torch
import torch.nn as nn
import torch.nn.functional as F
import torchvision
import mmcv


class Model(nn.Module):
    """ Model
    """

    def __init__(self,):
        super().__init__()
        self.initialize_weights()

    def initialize_weights(self):
        # initialization
        torch.nn.init.normal_(self.cls_token, std=.02)
        torch.nn.init.normal_(self.mask_token, std=.02)

        # initialize nn.Linear and nn.LayerNorm
        self.apply(self._init_weights)

    def _init_weights(self, m):
        if isinstance(m, nn.Linear):
            # we use xavier_uniform following official JAX ViT:
            torch.nn.init.xavier_uniform_(m.weight)
            if isinstance(m, nn.Linear) and m.bias is not None:
                nn.init.constant_(m.bias, 0)
        elif isinstance(m, nn.LayerNorm):
            nn.init.constant_(m.bias, 0)
            nn.init.constant_(m.weight, 1.0)

    def forward_model(self, x):
        pass

    def forward_loss(self, pred, gt):
        pass

    def forward(self, x, gt):
        pass
