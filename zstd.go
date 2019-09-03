package sarama

import "github.com/klauspost/compress/zstd"

func zstdDecompress(dst, src []byte) ([]byte, error) {
	decoder, _ := zstd.NewReader(nil)
	return decoder.DecodeAll(src, make([]byte, 0, len(src)))
}

func zstdCompressLevel(dst, src []byte, level int) ([]byte, error) {
	zStdLevel := zstd.EncoderLevelFromZstd(level)
	encoder, _ := zstd.NewWriter(nil, zstd.WithEncoderLevel(zStdLevel))
	return encoder.EncodeAll(src, make([]byte, 0, len(src))), nil
}
