import GPUImage
import QuartzCore

let filterOperations: Array<FilterOperationInterface> = [
    FilterOperation (
        filter:{RGBAdjustment()},
        listName:"aile",
        titleName:"爱乐",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.green = sliderValue
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
        filter:{RGBAdjustment()},
        listName:"april",
        titleName:"四月",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.blue = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{RGBAdjustment()},
        listName:"caomulv",
        titleName:"草木绿",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.green = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{RGBAdjustment()},
        listName:"chaotuo",
        titleName:"超脱",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.blue = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{RGBAdjustment()},
        listName:"chunzhen",
        titleName:"纯真",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.red = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{RGBAdjustment()},
        listName:"fenchun",
        titleName:"粉唇",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.red = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{RGBAdjustment()},
        listName:"hongchun",
        titleName:"红润",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.red = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{RGBAdjustment()},
        listName:"jiaopi",
        titleName:"俏皮",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.blue = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{RGBAdjustment()},
        listName:"mianhuatang",
        titleName:"棉花糖",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.red = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{RGBAdjustment()},
        listName:"musi",
        titleName:"缪斯",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.red = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{RGBAdjustment()},
        listName:"qimiao",
        titleName:"奇妙",
        sliderConfiguration:.enabled(minimumValue:0.0, maximumValue:2.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.red = sliderValue
        },
        filterOperationType:.singleInput
    ),
    FilterOperation(
        filter:{BrightnessAdjustment()},
        listName:"qingxin",
        titleName:"清新",
        sliderConfiguration:.enabled(minimumValue:-1.0, maximumValue:1.0, initialValue:0.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.brightness = sliderValue
    },
        filterOperationType:.singleInput
    ),
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
        filter:{ColorBlend()},
        listName:"taohua",
        titleName:"桃花",
        sliderConfiguration:.disabled,
        sliderUpdateCallback: nil,
        filterOperationType:.blend
    ),
    FilterOperation(
        filter:{MissEtikateFilter()},
        listName:"wennuan",
        titleName:"温暖",
        sliderConfiguration:.disabled,
        sliderUpdateCallback: nil,
        filterOperationType:.singleInput
    )
]
