/** @type {import('next').NextConfig} */
const isProd = process.env.NODE_ENV === "production";
const nextConfig = {
    async headers() {
        return [
            {
                source: "/reserver/install",
                headers: [
                    {
                        key: "Content-Type",
                        value: "text/html; charset=utf-8",
                    },
                ],
            },
            {
                source: "/install",
                headers: [
                    {
                        key: "Content-Type",
                        value: "text/html; charset=utf-8",
                    },
                ],
            },
        ];
    },
    swcMinify: true,
    reactStrictMode: true,
    assetPrefix: isProd ? "/reserver/" : "",
    images: {
        unoptimized: true,
    },
};

module.exports = nextConfig;
