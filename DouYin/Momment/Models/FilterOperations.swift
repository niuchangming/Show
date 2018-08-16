import GPUImage
import QuartzCore

let filterOperations: Array<FilterOperationInterface> = [
    FilterOperation (
        filter:{SaturationAdjustment()},
        listName:"aile",
        titleName:"爱乐",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.5),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.saturation = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{RGBAdjustment()},
        listName:"cute",
        titleName:"可爱",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.green = sliderValue
    },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{ContrastAdjustment()},
        listName:"april",
        titleName:"四月",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:4.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.contrast = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{BrightnessAdjustment()},
        listName:"caomulv",
        titleName:"草木绿",
        sliderConfiguration:.enabled(minimumValue:-1.0, maximumValue:1.0, initialValue:0.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.brightness = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{LevelsAdjustment()},
        listName:"chaotuo",
        titleName:"超脱",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:1.0, initialValue:0.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.minimum = Color(red:Float(sliderValue), green:Float(sliderValue), blue:Float(sliderValue))
            filter.middle = Color(red:1.0, green:1.0, blue:1.0)
            filter.maximum = Color(red:1.0, green:1.0, blue:1.0)
            filter.minOutput = Color(red:0.0, green:0.0, blue:0.0)
            filter.maxOutput = Color(red:1.0, green:1.0, blue:1.0)
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{ExposureAdjustment()},
        listName:"chunzhen",
        titleName:"纯真",
        sliderConfiguration:.enabled(minimumValue:-4.0, maximumValue:4.0, initialValue:0.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.exposure = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{HueAdjustment()},
        listName:"fenchun",
        titleName:"粉唇",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:360.0, initialValue:90.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.hue = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{WhiteBalance()},
        listName:"hongchun",
        titleName:"红润",
        sliderConfiguration:.enabled(minimumValue:2500.0, maximumValue:7500.0, initialValue:5000.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.temperature = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{MonochromeFilter()},
        listName:"jiaopi",
        titleName:"俏皮",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:1.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.intensity = sliderValue
        },
        filterOperationType:.custom(filterSetupFunction:{(camera, filter, outputView) in
            let castFilter = filter as! MonochromeFilter
            camera --> castFilter --> outputView
            castFilter.color = Color(red:0.0, green:0.0, blue:1.0, alpha:1.0)
            return nil
        })
    ),
    FilterOperation(
        filter:{FalseColor()},
        listName:"mianhuatang",
        titleName:"棉花糖",
        sliderConfiguration:.disabled,
        sliderUpdateCallback:nil,
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{Sharpen()},
        listName:"musi",
        titleName:"缪斯",
        sliderConfiguration:.enabled(minimumValue:-1.0, maximumValue:4.0, initialValue:0.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.sharpness = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{UnsharpMask()},
        listName:"qimiao",
        titleName:"奇妙",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:5.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.intensity = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{GammaAdjustment()},
        listName:"qingxin",
        titleName:"清新",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:3.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.gamma = sliderValue
        },
        filterOperationType:.singleInput
    ),
// TODO : Tone curve
    FilterOperation(
        filter:{HighlightsAndShadows()},
        listName:"shengdai",
        titleName:"圣代",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:1.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.highlights = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{Haze()},
        listName:"taohua",
        titleName:"桃花",
        sliderConfiguration:.enabled(minimumValue:-0.2, maximumValue:0.2, initialValue:0.2),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.distance = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{SepiaToneFilter()},
        listName:"tianzhen",
        titleName:"天真",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:1.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.intensity = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{AmatorkaFilter()},
        listName:"tonghua",
        titleName:"童话",
        sliderConfiguration:.disabled,
        sliderUpdateCallback: nil,
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{MissEtikateFilter()},
        listName:"weiguang",
        titleName:"微光",
        sliderConfiguration:.disabled,
        sliderUpdateCallback: nil,
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{SoftElegance()},
        listName:"wennuan",
        titleName:"温暖",
        sliderConfiguration:.disabled,
        sliderUpdateCallback: nil,
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{ColorInversion()},
        listName:"xiangfen",
        titleName:"香氛",
        sliderConfiguration:.disabled,
        sliderUpdateCallback: nil,
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{Solarize()},
        listName:"xinjing",
        titleName:"心境",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:1.0, initialValue:0.5),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.threshold = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{BrightnessAdjustment()},
        listName:"qingxi",
        titleName:"清晰",
        sliderConfiguration:.enabled(minimumValue:-1.0, maximumValue:1.0, initialValue:0.3),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.brightness = sliderValue
    },
        filterOperationType:.singleInput
    )
]
