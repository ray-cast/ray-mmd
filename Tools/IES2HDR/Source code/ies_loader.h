#ifndef _H_IES_LOADER_H_
#define _H_IES_LOADER_H_

#include <vector>
#include <string>

// https://knowledge.autodesk.com/support/3ds-max/learn-explore/caas/CloudHelp/cloudhelp/2016/ENU/3DSMax/files/GUID-EA0E3DE0-275C-42F7-83EC-429A37B2D501-htm.html
class IESFileInfo
{
public:
	IESFileInfo();

	bool valid() const;

	const std::string& error() const;

public:
	float totalLights;
	float totalLumens;

	float candalaMult;

	std::int32_t typeOfPhotometric;
	std::int32_t typeOfUnit;

	std::int32_t anglesNumH;
	std::int32_t anglesNumV;

	float width;
	float length;
	float height;

	float ballastFactor;
	float futureUse;
	float inputWatts;

private:
	friend class IESLoadHelper;

	float _cachedIntegral;

	std::string _error;
	std::string _version;

	std::vector<float> _anglesH;
	std::vector<float> _anglesV;
	std::vector<float> _candalaValues;
};

struct IESOutputData
{
	std::uint32_t width;
	std::uint32_t height;
	std::vector<float> stream;
};

class IESLoadHelper final
{
public:
	IESLoadHelper();
	~IESLoadHelper();

	bool load(const std::string& data, IESFileInfo& info);
	bool load(const char* data, std::size_t dataLength, IESFileInfo& info);

	bool saveAs1D(const IESFileInfo& info, IESOutputData& IESOutputData);
	bool saveAs2D(const IESFileInfo& info, IESOutputData& IESOutputData);

private:
	float computeInvMax(const std::vector<float>& candalaValues) const;
	float computeFilterPos(float value, const std::vector<float>& angle) const;

	float interpolate1D(const IESFileInfo& info, float angle) const;
	float interpolate2D(const IESFileInfo& info, float angleV, float angleH) const;
	float interpolatePoint(const IESFileInfo& info, int x, int y) const;
	float interpolateBilinear(const IESFileInfo& info, float x, float y) const;

	static void skipSpaceAndLineEnd(const std::string& data, std::string& out, bool stopOnComma = false);

	static void getLineContent(const std::string& data, std::string& next, std::string& line, bool stopOnWhiteSpace, bool stopOnComma);
	static void getFloat(const std::string& data, std::string& next, float& ret, bool stopOnWhiteSpace = true, bool stopOnComma = false);
	static void getInt(const std::string& data, std::string& next, std::int32_t& ret, bool stopOnWhiteSpace = true, bool stopOnComma = false);
};

#endif