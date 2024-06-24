//
//  Waves.metal
//  dont-slip
//
//  Created by Reyhan Ariq Syahalam on 20/06/24.
//

#include <metal_stdlib>
using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float2 texCoord [[attribute(1)]];
};

struct VertexOut {
    float4 position [[position]];
    float2 texCoord;
};

vertex VertexOut vertex_main(VertexIn in [[stage_in]], constant float &time [[buffer(1)]]) {
    VertexOut out;
    float wave = sin(in.position.x * 10.0 + time * 5.0) * 0.05;
    out.position = float4(in.position.x, in.position.y + wave, in.position.z, 1.0);
    out.texCoord = in.texCoord;
    return out;
}

fragment half4 fragment_main(VertexOut in [[stage_in]], texture2d<float> colorTexture [[texture(0)]], sampler colorSampler [[sampler(0)]]) {
    return colorTexture.sample(colorSampler, in.texCoord);
}
