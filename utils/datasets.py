import os
import PIL

from torchvision import datasets, transforms
import torch
import numpy as np

from timm.data import create_transform
from timm.data.constants import IMAGENET_DEFAULT_MEAN, IMAGENET_DEFAULT_STD


def build_dataset(is_train, args):
    transform = build_transform(is_train, args)

    root = os.path.join(args.data_path, 'train' if is_train else 'val')
    dataset = datasets.ImageFolder(root, transform=transform)

    print(dataset)

    return dataset


def build_transform(is_train, args):
    mean = IMAGENET_DEFAULT_MEAN
    std = IMAGENET_DEFAULT_STD
    # train transform
    if is_train:
        # this should always dispatch to transforms_imagenet_train
        transform = create_transform(
            input_size=args.input_size,
            is_training=True,
            color_jitter=args.color_jitter,
            auto_augment=args.aa,
            interpolation='bicubic',
            re_prob=args.reprob,
            re_mode=args.remode,
            re_count=args.recount,
            mean=mean,
            std=std,
        )
        return transform

    # eval transform
    t = []
    if args.input_size <= 224:
        crop_pct = 224 / 256
    else:
        crop_pct = 1.0
    size = int(args.input_size / crop_pct)
    t.append(
        # to maintain same ratio w.r.t. 224 images
        transforms.Resize(size, interpolation=PIL.Image.BICUBIC),
    )
    t.append(transforms.CenterCrop(args.input_size))

    t.append(transforms.ToTensor())
    t.append(transforms.Normalize(mean, std))
    return transforms.Compose(t)


def vis_transfrom(img_transformed, mean=IMAGENET_DEFAULT_MEAN, std=IMAGENET_DEFAULT_STD):
    # return numpy plt format
    # for check the dataset and  visualization
    # input transformed tensor [0,1]
    img_transformed = img_transformed.clone()
    x = img_transformed * torch.tensor(std).view(3, 1, 1)
    x = x+torch.tensor(mean).view(3, 1, 1)
    x = torch.clip(x*255, 0, 255)
    x = x.permute(1, 2, 0).numpy().astype(np.uint8)
    return x
