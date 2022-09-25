/** @type {import('next').NextConfig} */
const isProd = process.env.NODE_ENV === "production";
const nextConfig = {
    swcMinify: true,
    reactStrictMode: true,
    images: {
        domains: ["img.shields.io"],
    },
    assetPrefix: isProd ? "/reserver/" : "",
    images: {
        unoptimized: true,
    },
    async headers() {
        return [
            {
                source: "/install",
                headers: [
                    {
                        key: "Content-Type",
                        value: "text/html",
                    },
                ],
            },
        ];
    },
};

module.exports = nextConfig;
